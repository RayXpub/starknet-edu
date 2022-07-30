%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from src.lib.UTILS import (
    UTILS_assert_uint256_difference,
    UTILS_assert_uint256_eq,
    UTILS_assert_uint256_le,
    UTILS_assert_uint256_strictly_positive,
    UTILS_assert_uint256_zero,
    UTILS_assert_uint256_lt,
)
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from src.interfaces.IExerciseSolution import IExerciseSolution
from src.interfaces.IDTKERC20 import IDTKERC20
from src.interfaces.IERC20 import IERC20
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_add,
    uint256_sub,
    uint256_mul,
    uint256_le,
    uint256_lt,
    uint256_check,
    uint256_eq,
    uint256_neg,
)

@external
func __setup__{syscall_ptr : felt*, range_check_ptr}():
    # deploy
    alloc_locals
    local recepient = 0x032606728a76Ef9576024D3d04586322D659BC8Bb777158B7d627a2b3E75C14C
    %{
        context.dtk_address = deploy_contract("./src/DTKERC20.cairo",[90997221901889128397906381721202537008, 293471990320, 600000000000000000000, 0, ids.recepient]).contract_address
        context.est_address = deploy_contract("./src/ExerciseSolutionToken.cairo", [600000000000000000000, 0, ids.recepient]).contract_address
        context.contract_address = deploy_contract("./src/ExerciseSolution.cairo", [context.dtk_address, context.est_address]).contract_address
    %}
    return()
end

@external
func test_claimed_from_contract{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local submitted_exercise_address: felt
    local dtk_address: felt
    %{ 
        ids.submitted_exercise_address = context.contract_address
        ids.dtk_address = context.dtk_address
    %}
    # Reading addresses
    let (evaluator_address) = get_contract_address()
    let (sender_address) = get_caller_address()

    # Initial state
    let (initial_dtk_custody) = IExerciseSolution.tokens_in_custody(
        contract_address=submitted_exercise_address, account=evaluator_address
    )
    # Initial balance of ExerciseSolution (used to check that the faucet was called during this execution)
    let (initial_solution_dtk_balance) = IDTKERC20.balanceOf(
        dtk_address, submitted_exercise_address
    )

    # Claiming tokens for the evaluator
    let (claimed_amount) = IExerciseSolution.get_tokens_from_contract(submitted_exercise_address)

    # Checking that the amount returned is positive
    UTILS_assert_uint256_strictly_positive(claimed_amount)

    # Checking that the amount in custody increased
    let (final_dtk_custody) = IExerciseSolution.tokens_in_custody(
        contract_address=submitted_exercise_address, account=evaluator_address
    )
    let (custody_difference) = uint256_sub(final_dtk_custody, initial_dtk_custody)
    UTILS_assert_uint256_strictly_positive(custody_difference)

    # Checking that the amount returned is the same as the custody balance increase
    UTILS_assert_uint256_eq(custody_difference, claimed_amount)

    # Finally, checking that the balance of ExerciseSolution was also increased by the same amount
    let (final_solution_dtk_balance) = IDTKERC20.balanceOf(
        dtk_address, submitted_exercise_address
    )
    UTILS_assert_uint256_difference(
        final_solution_dtk_balance, initial_solution_dtk_balance, custody_difference
    )

    return()
end

@external
func test_deposit_tokens{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local submitted_exercise_address: felt
    local dtk_address: felt
    %{ 
        ids.submitted_exercise_address = context.contract_address
        ids.dtk_address = context.dtk_address
    %}
    # Reading addresses
    let (evaluator_address) = get_contract_address()
    let (sender_address) = get_caller_address()
    IDTKERC20.faucet(contract_address=dtk_address)

    # ############## Initial state
    # Reading initial balances of DTK
    let (initial_dtk_balance_eval) = IDTKERC20.balanceOf(dtk_address, evaluator_address)
    let (initial_dtk_balance_submission) = IDTKERC20.balanceOf(
        dtk_address, submitted_exercise_address
    )

    # Reading initial amount of DTK in custody of ExerciseSolution for Evaluator
    let (initial_dtk_custody) = IExerciseSolution.tokens_in_custody(
        contract_address=submitted_exercise_address, account=evaluator_address
    )

    # ############## Actions

    # Allow ExerciseSolution to spend 10 DTK of Evaluator
    let ten_tokens_uint256 : Uint256 = Uint256(10 * 1000000000000000000, 0)
    IERC20.approve(dtk_address, submitted_exercise_address, ten_tokens_uint256)

    # Deposit them into ExerciseSolution
    let (total_custody) = IExerciseSolution.deposit_tokens(
        contract_address=submitted_exercise_address, amount=ten_tokens_uint256
    )

    # ############## Balances check
    # Check that ExerciseSolution's balance of DTK also increased by ten tokens
    let (final_dtk_balance_submission) = IDTKERC20.balanceOf(
        dtk_address, submitted_exercise_address
    )
    UTILS_assert_uint256_difference(
        final_dtk_balance_submission, initial_dtk_balance_submission, ten_tokens_uint256
    )

    # Check that Evaluator's balance of DTK decreased by ten tokens
    let (final_dtk_balance_eval) = IDTKERC20.balanceOf(dtk_address, evaluator_address)
    %{
        print("final_dtk_balance_eval", ids.final_dtk_balance_eval.low)
        print("initial_dtk_balance_eval", ids.initial_dtk_balance_eval.low)
    %}
    UTILS_assert_uint256_difference(
        initial_dtk_balance_eval, final_dtk_balance_eval, ten_tokens_uint256
    )

    # ############## Custody check
    # Check that the custody balance did increase by ten tokens
    let (final_dtk_custody) = IExerciseSolution.tokens_in_custody(
        submitted_exercise_address, evaluator_address
    )
    UTILS_assert_uint256_difference(final_dtk_custody, initial_dtk_custody, ten_tokens_uint256)

    return()
end

@external
func test_deposit_and_mint{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local submitted_exercise_address: felt
    local read_dtk_address: felt
    %{ 
        ids.submitted_exercise_address = context.contract_address
        ids.read_dtk_address = context.dtk_address
    %}
    # Reading addresses
    let (evaluator_address) = get_contract_address()
    let (sender_address) = get_caller_address()
    let (submitted_exercise_token_address) = IExerciseSolution.deposit_tracker_token(
        submitted_exercise_address
    )
    IDTKERC20.faucet(contract_address=read_dtk_address)

    # ############## Initial state
    # Reading ExerciseSolutionToken (est) supply and evaluator's initial balance
    let (initial_est_supply) = IERC20.totalSupply(submitted_exercise_token_address)
    let (initial_est_balance_eval) = IERC20.balanceOf(
        submitted_exercise_token_address, evaluator_address
    )

    # Reading initial balances of DTK
    let (initial_dtk_balance_eval) = IDTKERC20.balanceOf(read_dtk_address, evaluator_address)
    let (initial_dtk_balance_submission) = IDTKERC20.balanceOf(
        read_dtk_address, submitted_exercise_address
    )

    # ############## Actions
    # Allow ExerciseSolution to spend 10 DTK of Evaluator
    let ten_tokens_uint256 : Uint256 = Uint256(10 * 1000000000000000000, 0)
    IERC20.approve(read_dtk_address, submitted_exercise_address, ten_tokens_uint256)

    # Deposit them into ExerciseSolution
    IExerciseSolution.deposit_tokens(
        contract_address=submitted_exercise_address, amount=ten_tokens_uint256
    )

    # ############## Balances checks
    # Check that ExerciseSolution's balance of DTK also increased by ten tokens
    let (final_dtk_balance_submission) = IDTKERC20.balanceOf(
        read_dtk_address, submitted_exercise_address
    )
    UTILS_assert_uint256_difference(
        final_dtk_balance_submission, initial_dtk_balance_submission, ten_tokens_uint256
    )

    # Check that Evaluator's balance of DTK decreased by ten tokens
    let (final_dtk_balance_eval) = IDTKERC20.balanceOf(read_dtk_address, evaluator_address)
    UTILS_assert_uint256_difference(
        initial_dtk_balance_eval, final_dtk_balance_eval, ten_tokens_uint256
    )

    # ############## ExerciseSolutionToken checks
    let (final_est_supply) = IERC20.totalSupply(contract_address=submitted_exercise_token_address)
    let (minted_tokens) = uint256_sub(final_est_supply, initial_est_supply)

    # Check that evaluator's balance increased by the minted amount
    let (final_est_balance_eval) = IERC20.balanceOf(
        submitted_exercise_token_address, evaluator_address
    )
    UTILS_assert_uint256_difference(final_est_balance_eval, initial_est_balance_eval, minted_tokens)

    return ()
end