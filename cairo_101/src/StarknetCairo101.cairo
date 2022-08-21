%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc

from src.interfaces.IExercises import IEx01, IEx02, IEx03, IEx04, IEx05, IEx06, IEx07, IEx08, IEx09, IEx10, IEx10b, IEx11, IEx12, IEx13, IEx14

@storage_var
func exercises(id: felt) -> (address: felt):
end

@constructor
func constructor{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }():
    exercises.write(1, 0x29e2801df18d7333da856467c79aa3eb305724db57f386e3456f85d66cbd58b)
    exercises.write(2, 0x18ef3fa8b5938a0059fa35ee6a04e314281a3e64724fe094c80e3720931f83f)
    exercises.write(3, 0x79275e734d50d7122ef37bb939220a44d0b1ad5d8e92be9cdb043d85ec85e24)
    exercises.write(4, 0x2cca27cae57e70721d0869327cee5cb58098af4c74c7d046ce69485cd061df1)
    exercises.write(5, 0x399a3fdd57cad7ed2193bdbb00d84553cd449abbdfb62ccd4119eae96f827ad)
    exercises.write(6, 0x718ece7af4fb1d9c82f78b7a356910d8c2a8d47d4ac357db27e2c34c2424582)
    exercises.write(7, 0x3a1ad1cde69c9e7b87d70d2ea910522640063ccfb4875c3e33665f6f41d354a)
    exercises.write(8, 0x15fa754c386aed6f0472674559b75358cde49db8b2aba8da31697c62001146c)
    exercises.write(9, 0x2b9fcc1cfcb1ddf4663c8e7ac48fc87f84c91a8c2b99414c646900bf7ef5549)
    exercises.write(10, 0x8415762f4b0b0f44e42ac1d103ac93c3ea94450a15bb65b99bbcc816a9388)
    exercises.write(11, 0xab5577b9be8948d89dbdba63370a3de92e72a23c4cacaea38b3a74eec3a872)
    exercises.write(12, 0x24d15e02ddaa19d7ecd77204d35ed9bfff00a0cabc62eb3da5ba7680e44baf9)
    exercises.write(13, 0x2bae9190076c4252289b8a8671277cef57318192cff20c736808b0c71095895)
    exercises.write(14, 0xed7ddffe1370fbbc1974ab8122d1d9bd7e3da8d829ead9177ea4249b4caef1)
    return()
end

func _execute_ex01{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_01) = exercises.read(1)
    IEx01.claim_points(contract_address=_ex_01)
    
    return(1)
end

func _execute_ex02{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_02) = exercises.read(2)
    let (secret_value) = IEx02.my_secret_value(contract_address=_ex_02)
    IEx02.claim_points(contract_address=_ex_02, my_value=secret_value)

    return(1)
end

func _execute_ex03{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    alloc_locals
    let (local _ex_03) = exercises.read(3)
    let (address_this) = get_contract_address()
    let (counter) = IEx03.user_counters(contract_address=_ex_03, account=address_this)
    if counter == 7:
        IEx03.claim_points(contract_address=_ex_03)
        return (1)
    end
    let (is_counter_less) = is_le(counter, 7)
    if is_counter_less == 1:
        IEx03.increment_counter(contract_address=_ex_03)
    else :
        IEx03.decrement_counter(contract_address=_ex_03)
    end

    return _execute_ex03()
end

func _execute_ex04{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_04) = exercises.read(4)
    IEx04.assign_user_slot(contract_address=_ex_04)
    let (address_this) = get_contract_address()
    let (slot) = IEx04.user_slots(contract_address=_ex_04, account=address_this)
    let (value) = IEx04.values_mapped(contract_address=_ex_04, slot=slot)
    IEx04.claim_points(contract_address=_ex_04, expected_value=value - 32)
    
    return(1)
end

func _execute_ex05{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_05) = exercises.read(5)
    IEx05.assign_user_slot(contract_address=_ex_05)
    IEx05.copy_secret_value_to_readable_mapping(contract_address=_ex_05)
    let (address_this) = get_contract_address()
    let (value) = IEx05.user_values(contract_address=_ex_05, account=address_this)
    IEx05.claim_points(contract_address=_ex_05, expected_value=value)
    
    return(1)
end

func _execute_ex06{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_06) = exercises.read(6)
    IEx06.assign_user_slot(contract_address=_ex_06)
    IEx06.external_handler_for_internal_function(contract_address=_ex_06, a_value=0)
    let (address_this) = get_contract_address()
    let (value) = IEx06.user_values(contract_address=_ex_06, account=address_this)
    IEx06.claim_points(contract_address=_ex_06, expected_value=value)

    return (1)
end

func _execute_ex07{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_07) = exercises.read(7)
    IEx07.claim_points(contract_address=_ex_07, value_a=50, value_b=0)

    return (1)
end

func _execute_ex08{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    alloc_locals
    let (_ex_08) = exercises.read(8)
    let (address_this) = get_contract_address()
    let (local array) = alloc()
    assert [array] = 10
    assert [array + 1] = 9
    assert [array + 2] = 8
    assert [array + 3] = 7
    assert [array + 4] = 6
    assert [array + 5] = 5
    assert [array + 6] = 4
    assert [array + 7] = 3
    assert [array + 8] = 2
    assert [array + 9] = 1
    assert [array + 10] = 0
    IEx08.set_user_values(contract_address=_ex_08, account=address_this, array_len=11, array=array)
    IEx08.claim_points(contract_address=_ex_08)

    return (1)
end

func _execute_ex09{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    alloc_locals
    let (_ex_09) = exercises.read(9)
    let (local array) = alloc()
    assert [array] = 32
    assert [array + 1] = 16
    assert [array + 2] = 8
    assert [array + 3] = 4
    assert [array + 4] = 2
    IEx09.claim_points(contract_address=_ex_09, array_len=5, array=array)

    return (1)
end

func _execute_ex10{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_10) = exercises.read(10)
    let (_ex_10_b) = IEx10.ex10b_address(contract_address=_ex_10)
    let (value) = IEx10b.secret_value(contract_address=_ex_10_b)
    IEx10.claim_points(contract_address=_ex_10, secret_value_i_guess=value, next_secret_value_i_chose=value + 1)

    return (1)
end

func _execute_ex11{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_11) = exercises.read(11)
    let (fake_value) = IEx11.secret_value(contract_address=_ex_11)
    let value = fake_value - 42069
    IEx11.claim_points(contract_address=_ex_11, secret_value_i_guess=value, next_secret_value_i_chose=value + 1)

    return (1)
end

func _execute_ex12_a{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_12) = exercises.read(12)
    IEx12.assign_user_slot(contract_address=_ex_12)

    return (1)
end

@external
func execute_ex13{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(expected_value: felt) -> (success: felt):
    let (_ex_13) = exercises.read(13)
    IEx13.assign_user_slot(contract_address=_ex_13)
    IEx13.claim_points(contract_address=_ex_13, expected_value=expected_value)
    return (1)
end

@external
func execute_ex12_b{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(expected_value : felt) -> (success: felt):
    let (_ex_12) = exercises.read(12)
    IEx12.claim_points(contract_address=_ex_12, expected_value=expected_value)

    return (1)
end

@external
func execute_ex14{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (success: felt):
    let (_ex_14) = exercises.read(14)
    IEx14.claim_points(contract_address=_ex_14)

    return (1)
end

@external
func validate_various_exercices{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }():
    _execute_ex01()
    _execute_ex02()
    _execute_ex03()
    _execute_ex04()
    _execute_ex05()
    _execute_ex06()
    _execute_ex07()
    _execute_ex08()
    _execute_ex09()
    _execute_ex10()
    _execute_ex11()
    _execute_ex12_a()

    return ()
end
