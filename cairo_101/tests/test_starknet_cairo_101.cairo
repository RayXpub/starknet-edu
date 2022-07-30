%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from src.interfaces.IStarknetCairo101 import IStarknetCairo101
from src.utils.Iplayers_registry import Iplayers_registry
from src.token.ITDERC20 import ITDERC20
from src.token.IERC20 import IERC20
from protostar.asserts import (
    assert_eq, assert_not_eq, assert_signed_lt, assert_signed_le, assert_signed_gt,
    assert_unsigned_lt, assert_unsigned_le, assert_unsigned_gt, assert_signed_ge,
    assert_unsigned_ge)
from src.interfaces.IExercises import IEx01, IEx02, IEx03, IEx04, IEx05, IEx06, IEx07, IEx08, IEx09, IEx10, IEx10b, IEx11, IEx12, IEx13, IEx14

@external
func __setup__{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    let (local owner) = get_contract_address()
    local recipient = 0x07708BB8123B5dFD09c755B393aa56aE515C6a8F41fEe678746436Cb1Cde15AE
    %{
        context.tderc20_address = deploy_contract("./src/token/TDERC20.cairo", [10057515165931654559836545801321088512241713, 357609582641, 40242000000000000000000, 0, ids.recipient, ids.owner]).contract_address
        context.players_registry_address = deploy_contract("./src/utils/players_registry.cairo", [ids.owner]).contract_address
        context.ex01_address = deploy_contract("./src/ex01.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            1
        ]).contract_address
        context.ex02_address = deploy_contract("./src/ex02.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            2,
            7
        ]).contract_address
        context.ex03_address = deploy_contract("./src/ex03.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            3 
        ]).contract_address
        context.ex04_address = deploy_contract("./src/ex04.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            4
        ]).contract_address
        context.ex05_address = deploy_contract("./src/ex05.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            5
        ]).contract_address
        context.ex06_address = deploy_contract("./src/ex06.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            6
        ]).contract_address
        context.ex07_address = deploy_contract("./src/ex07.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            7
        ]).contract_address
        context.ex08_address = deploy_contract("./src/ex08.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            8
        ]).contract_address
        context.ex09_address = deploy_contract("./src/ex09.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            9
        ]).contract_address
        context.ex10_address = deploy_contract("./src/ex10.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            10
        ]).contract_address
        context.ex10b_address = deploy_contract("./src/ex10b.cairo", [
            context.ex10_address
        ]).contract_address
        context.ex11_address = deploy_contract("./src/ex11.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            11
        ]).contract_address
        context.ex12_address = deploy_contract("./src/ex12.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            12
        ]).contract_address
        context.ex13_address = deploy_contract("./src/ex13.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            13
        ]).contract_address
        context.ex14_address = deploy_contract("./src/ex14.cairo", [
            context.tderc20_address,
            context.players_registry_address,
            1,
            14
        ]).contract_address
        context.starknet_101_address = deploy_contract("./src/TestStarknet101.cairo", [
            context.ex01_address,
            context.ex02_address,
            context.ex03_address,
            context.ex04_address,
            context.ex05_address,
            context.ex06_address,
            context.ex07_address,
            context.ex08_address,
            context.ex09_address,
            context.ex10_address,
            context.ex11_address,
            context.ex12_address,
            context.ex13_address,
            context.ex14_address,
        ]).contract_address
        print("starknet_101", hex(context.starknet_101_address))
        print("tderc20", hex(context.tderc20_address))
        print("players_registry", hex(context.players_registry_address))
        print("ex_14", hex(context.ex14_address))
    %}

    local ex01_address: felt
    local ex02_address: felt
    local ex03_address: felt
    local ex04_address: felt
    local ex05_address: felt
    local ex06_address: felt
    local ex07_address: felt
    local ex08_address: felt
    local ex09_address: felt
    local ex10_address: felt
    local ex11_address: felt
    local ex12_address: felt
    local ex13_address: felt
    local ex14_address: felt
    local players_registry_address: felt
    local tderc20_address: felt

    %{
        ids.ex01_address = context.ex01_address
        ids.ex02_address = context.ex02_address
        ids.ex03_address = context.ex03_address
        ids.ex04_address = context.ex04_address
        ids.ex05_address = context.ex05_address
        ids.ex06_address = context.ex06_address
        ids.ex07_address = context.ex07_address
        ids.ex08_address = context.ex08_address
        ids.ex09_address = context.ex09_address
        ids.ex10_address = context.ex10_address
        ids.ex11_address = context.ex11_address
        ids.ex12_address = context.ex12_address
        ids.ex13_address = context.ex13_address
        ids.ex14_address = context.ex14_address
        ids.players_registry_address = context.players_registry_address
        ids.tderc20_address = context.tderc20_address
    %}

    let (local exercises) = alloc()
    assert [exercises] = ex01_address
    assert [exercises + 1] = ex02_address
    assert [exercises + 2] = ex03_address
    assert [exercises + 3] = ex04_address
    assert [exercises + 4] = ex05_address
    assert [exercises + 5] = ex06_address
    assert [exercises + 6] = ex07_address
    assert [exercises + 7] = ex08_address
    assert [exercises + 8] = ex09_address
    assert [exercises + 9] = ex10_address
    assert [exercises + 10] = ex11_address
    assert [exercises + 11] = ex12_address
    assert [exercises + 12] = ex13_address
    assert [exercises + 13] = ex14_address

    Iplayers_registry.set_exercises_or_admins(contract_address=players_registry_address, accounts_len=14, accounts=exercises)
    ITDERC20.set_teachers(contract_address=tderc20_address, accounts_len=14, accounts=exercises)

    return ()
end

@external
func test_ex01{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex01(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return ()
end

@external
func test_ex02{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex02(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex03{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex03(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex04{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex04(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex05{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex05(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex06{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex06(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex07{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex07(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex08{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex08(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex09{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex09(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex10{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex10(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex11{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}

    IStarknetCairo101.execute_ex11(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex12{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex12_a(contract_address=starknet_101_address)
    IStarknetCairo101.execute_ex12_b(contract_address=starknet_101_address, expected_value=0)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex13{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
    %}
    IStarknetCairo101.execute_ex13(contract_address=starknet_101_address)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(2 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end

@external
func test_ex14{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals
    local starknet_101_address: felt
    local tderc20_address: felt
    local ex14_address: felt
    %{
        ids.starknet_101_address = context.starknet_101_address
        ids.tderc20_address = context.tderc20_address
        ids.ex14_address = context.ex14_address
    %}
    IStarknetCairo101.execute_ex14(contract_address=starknet_101_address)
    
    IStarknetCairo101.execute_ex12_b(contract_address=starknet_101_address, expected_value=0)
    let (points) = IERC20.balanceOf(contract_address=tderc20_address, account=starknet_101_address)

    let (success) = uint256_eq(points, Uint256(28 * 1000000000000000000, 0))
    assert_eq(success, 1)

    return () 
end