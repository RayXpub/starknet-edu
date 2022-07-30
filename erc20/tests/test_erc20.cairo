%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import (Uint256, uint256_lt, uint256_sub, uint256_eq)
from src.interfaces.IERC20Solution import IERC20Solution
from src.interfaces.IERC20 import IERC20
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from protostar.asserts import (
    assert_eq, assert_not_eq, assert_signed_lt, assert_signed_le, assert_signed_gt,
    assert_unsigned_lt, assert_unsigned_le, assert_unsigned_gt, assert_signed_ge,
    assert_unsigned_ge)

@external
func __setup__{syscall_ptr : felt*, range_check_ptr}():
    alloc_locals
    local recepient = 0x032606728a76Ef9576024D3d04586322D659BC8Bb777158B7d627a2b3E75C14C
    local dtk_address = 0x6cf7610c6209b72980c39196bb94b0d1c952dc1248be14cf149ed16a2c5864f
    %{
        context.est_address = deploy_contract("./src/ExerciseSolutionToken.cairo", [600000000000000000000, 0, ids.recepient]).contract_address
        print("Exercise Solution Token Address", context.est_address)
        context.contract_address = deploy_contract("./src/ExerciseSolution.cairo", [ids.dtk_address, context.est_address]).contract_address
        print("Exercise Solution Address", context.contract_address)
    %}
    return()
end

@external
func test_fencing{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local test_erc20_address: felt
    %{ ids.test_erc20_address = context.contract_address%}
    # Reading addresses
    let (evaluator_address) = get_contract_address()
    let (sender_address) = get_caller_address()

    # Check that Evaluator is not allowed to get tokens
    let (allowlist_level_eval) = IERC20Solution.allowlist_level(
        contract_address=test_erc20_address, account=evaluator_address
    )

    with_attr error_message("Allowlist_level did not return 0 initially"):
        assert_eq(allowlist_level_eval, 0)
    end

    # Try to get token. We use `_` to show that we do not intend to use the second returned value.
    let (has_received_tokens, _) = test_get_tokens(test_erc20_address)

    # Checking that nothing happened
    with_attr error_message("It was possible to get tokens from the start"):
        assert_eq(has_received_tokens, 0)
    end

    # Get whitelisted by asking politely
    let (whitelisted) = IERC20Solution.request_allowlist(
        contract_address=test_erc20_address
    )

    with_attr error_message("request_allowlist did not return the correct value"):
        assert_eq(whitelisted, 1)
    end

    # Check that Evaluator is whitelisted
    let (allowlist_level_eval) = IERC20Solution.allowlist_level(
        test_erc20_address, evaluator_address
    )
    with_attr error_message("Allowlist_level did not return the correct value"):
        assert_signed_gt(allowlist_level_eval, 0)
    end
    # Check that we can now get tokens
    let (has_received_tokens, _) = test_get_tokens(test_erc20_address)

    with_attr error_message("Got no tokens when I should have"):
        assert_eq(has_received_tokens, 1)
    end

    return()
end

func test_get_tokens{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tested_contract : felt
) -> (has_received_tokens : felt, amount_received : Uint256):
    # This function will
    # * get initial evaluator balance on the given contract,
    # * call that contract's `get_tokens`
    # * get the evaluator's final balance
    # and return two values:
    # * Whether the evaluator's balance increased or not
    # * The balance difference (amount)
    # It will also make sure that the two values are consistent (asserts will fail otherwise)
    alloc_locals
    let (evaluator_address) = get_contract_address()

    let (initial_balance) = IERC20.balanceOf(
        contract_address=tested_contract, account=evaluator_address
    )
    let (amount_received) = IERC20Solution.get_tokens(contract_address=tested_contract)

    # Checking returned value
    let zero_as_uint256 : Uint256 = Uint256(0, 0)
    let (has_received_tokens) = uint256_lt(zero_as_uint256, amount_received)

    # Checking that current balance is initial_balance + amount_received (even if 0)
    let (final_balance) = IERC20.balanceOf(
        contract_address=tested_contract, account=evaluator_address
    )

    UTILS_assert_uint256_difference(final_balance, initial_balance, amount_received)

    return (has_received_tokens, amount_received)
end

func UTILS_assert_uint256_difference{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(after : Uint256, before : Uint256, expected_difference : Uint256):
    let (calculated_difference) = uint256_sub(after, before)
    let (calculated_is_expected) = uint256_eq(calculated_difference, expected_difference)
    assert calculated_is_expected = 1
    return ()
end