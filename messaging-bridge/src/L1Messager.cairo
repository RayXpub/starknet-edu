%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.messages import send_message_to_l1
from starkware.cairo.common.alloc import alloc

@storage_var
func l1_messaging_nft() -> (address: felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    l1_messaging_nft.write(0x6DD77805FD35c91EF6b2624Ba538Ed920b8d0b4E)
    return ()
end

@external
func create_l1_nft_message{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    l1_user : felt
):
    # Sending the Mint message.
    let (message_payload : felt*) = alloc()
    assert message_payload[0] = l1_user 
    let (_l1_messaging_nft) = l1_messaging_nft.read()
    send_message_to_l1(to_address=_l1_messaging_nft, payload_size=1, payload=message_payload)
    return ()
end