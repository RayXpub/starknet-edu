%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from src.ERC20_base import (
    ERC20_name,
    ERC20_symbol,
    ERC20_totalSupply,
    ERC20_decimals,
    ERC20_balanceOf,
    ERC20_allowance,
    ERC20_mint,

    ERC20_initializer,
    ERC20_approve,
    ERC20_increaseAllowance,
    ERC20_decreaseAllowance,
    ERC20_transfer,
    ERC20_transferFrom
)

@constructor
func constructor{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        name: felt,
        symbol: felt,
        initial_supply: Uint256,
        recipient: felt,
    ):
    ERC20_initializer(name, symbol, initial_supply, recipient)
    return ()
end

@storage_var
func allowlist(account : felt) -> (allowlist_level: felt):
end

@storage_var
func levelAmount(level: felt) -> (level_amount: felt):
end

@storage_var
func levelCounter() -> (level_counter: felt):
end

#
# Getters
#

@view
func name{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (name: felt):
    let (name) = ERC20_name()
    return (name)
end

@view
func symbol{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (symbol: felt):
    let (symbol) = ERC20_symbol()
    return (symbol)
end

@view
func totalSupply{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (totalSupply: Uint256):
    let (totalSupply: Uint256) = ERC20_totalSupply()
    return (totalSupply)
end

@view
func decimals{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (decimals: felt):
    let (decimals) = ERC20_decimals()
    return (decimals)
end

@view
func balanceOf{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account: felt) -> (balance: Uint256):
    let (balance: Uint256) = ERC20_balanceOf(account)
    return (balance)
end

@view
func allowance{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(owner: felt, spender: felt) -> (remaining: Uint256):
    let (remaining: Uint256) = ERC20_allowance(owner, spender)
    return (remaining)
end

@view
func allowlist_level{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(account: felt) -> (allowlist_level_eval : felt):
    let (allowlist_level) = allowlist.read(account)
    return (allowlist_level_eval=allowlist_level)
end

#
# Externals
#

@external
func get_tokens{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (amount_received: Uint256):
    let (sender_address) = get_caller_address()
    let (allowlist_level) = allowlist.read(sender_address)
    let (caller) = get_caller_address()
    if allowlist_level == 0 :
        return (amount_received=Uint256(0, 0))
    end
    # if allowlist_level == 1 :
    #     let amount = Uint256(100*1000000000000000000, 0)
    #     ERC20_mint(caller, amount)
    #     return (amount)
    # end

    let amount = Uint256(1, 0)
    ERC20_mint(caller, amount)
    
    return (amount_received=amount)

    # Cairo equivalent to 'return (true)'
end

@external
func transfer{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(recipient: felt, amount: Uint256) -> (success: felt):
    ERC20_transfer(recipient, amount)
    # Cairo equivalent to 'return (true)'
    return (1)
end

@external
func transferFrom{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        sender: felt, 
        recipient: felt, 
        amount: Uint256
    ) -> (success: felt):
    ERC20_transferFrom(sender, recipient, amount)
    # Cairo equivalent to 'return (true)'
    return (1)
end

@external
func approve{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(spender: felt, amount: Uint256) -> (success: felt):
    ERC20_approve(spender, amount)
    # Cairo equivalent to 'return (true)'
    return (1)
end

@external
func increaseAllowance{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(spender: felt, added_value: Uint256) -> (success: felt):
    ERC20_increaseAllowance(spender, added_value)
    # Cairo equivalent to 'return (true)'
    return (1)
end

@external
func decreaseAllowance{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(spender: felt, subtracted_value: Uint256) -> (success: felt):
    ERC20_decreaseAllowance(spender, subtracted_value)
    # Cairo equivalent to 'return (true)'
    return (1)
end

# @external
# func request_allowlist_level{syscall_ptr: felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level_requested: felt) -> (level: felt):
#     let (sender_address) = get_caller_address()
#     allowlist.write(sender_address, level_requested)
#     return (level=level_requested)
# end

@external
func request_allowlist{syscall_ptr: felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (level: felt):
    let (sender_address) = get_caller_address()
    allowlist.write(sender_address, 1)
    return (1)
end

@external
func set_levels_amount{syscall_ptr: felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(level_amounts_len: felt, level_amounts: felt*):
    if level_amounts_len == 0:
        return ()
    end

    let amount = [level_amounts]
    let (level_counter) = levelCounter.read()
    levelCounter.write(level_counter + 1)
    levelAmount.write(level_counter + 1, amount)
        
    return set_levels_amount(level_amounts_len - 1, level_amounts=level_amounts + 1)
end