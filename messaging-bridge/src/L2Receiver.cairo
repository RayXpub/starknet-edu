%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func l1_assigned_var() -> (value: felt)
end

@view
func l1_assigned_var{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    let (value) = l1_assigned_var.read()
    return (value)
end

@l1_handler
func receiver{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    from_address : felt, random_value: felt)
):  
    l1_assigned_var.write(random_value)
    
    return()
end