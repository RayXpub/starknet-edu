%lang starknet

from starkware.cairo.common.uint256 import (Uint256, uint256_sub, uint256_add)
from src.interfaces.IDTKERC20 import IDTKERC20
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from src.interfaces.IExerciseSolutionToken import IExerciseSolutionToken


@storage_var
func dtk_address() -> (address: felt):
end

@storage_var
func holder_balance(address: felt) -> (balance: Uint256):
end

@storage_var
func tracker_token() -> (address: felt):
end

@constructor
func constructor{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(_dtk_address: felt, _deposit_tracker_token: felt):
    with_attr error_message("Cannot set to 0"):
        assert_not_zero(_dtk_address)
        assert_not_zero(_deposit_tracker_token)
    end
    dtk_address.write(_dtk_address)
    tracker_token.write(_deposit_tracker_token)

    return()
end

@view
func tokens_in_custody{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(holder: felt) -> (amount: Uint256):
    let (balance) = holder_balance.read(holder)
    return (balance)
end

@view
func deposit_tracker_token{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (address: felt):
    let (token) = tracker_token.read()
    return (token)
end

# CEI pattern not resepected
@external
func get_tokens_from_contract{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (amount: Uint256):
    let (caller) = get_caller_address()
    let (exercise_solution_address) = get_contract_address()
    let (_dtk_address) = dtk_address.read()
    let (balance_before) = IDTKERC20.balanceOf(contract_address=_dtk_address, account=exercise_solution_address)
    IDTKERC20.faucet(contract_address=_dtk_address)
    let (balance_after) = IDTKERC20.balanceOf(contract_address=_dtk_address, account=exercise_solution_address)
    let (claimed_amount) = uint256_sub(balance_after, balance_before)
    holder_balance.write(caller, claimed_amount)
    
    return (claimed_amount)
end

@external
func withdraw_all_tokens{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (amount: Uint256):
    let (caller) = get_caller_address()
    let (caller_balance) = holder_balance.read(caller)
    let (_dtk_address) = dtk_address.read()
    let (_deposit_tracker_token) = tracker_token.read()
    holder_balance.write(caller, Uint256(0,0))
    IDTKERC20.transfer(contract_address=_dtk_address, recipient=caller, amount=caller_balance)
    IExerciseSolutionToken.burn(contract_address=_deposit_tracker_token, account=caller, amount=caller_balance)

    return (caller_balance)
end

@external
func deposit_tokens{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(amount: Uint256) -> (total_amount: Uint256):
    let (caller) = get_caller_address()
    let (exercise_solution_address) = get_contract_address()
    let (_dtk_address) = dtk_address.read()
    let (_deposit_tracker_token) = tracker_token.read()
    let (holder_balance_before) = holder_balance.read(caller)
    let (new_holder_balance, is_overflow) = uint256_add(holder_balance_before, amount)
    assert (is_overflow) = 0
    holder_balance.write(caller, new_holder_balance)
    IDTKERC20.transferFrom(contract_address=_dtk_address, sender=caller, recipient=exercise_solution_address, amount=amount)
    IExerciseSolutionToken.mint(contract_address=_deposit_tracker_token, account=caller, amount=amount)
    
    return (new_holder_balance)
end