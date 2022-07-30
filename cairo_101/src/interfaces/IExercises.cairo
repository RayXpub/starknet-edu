%lang starknet

@contract_interface
namespace IEx01 :
    func claim_points():
    end
end

@contract_interface
namespace IEx02:
    func my_secret_value() -> (my_secret_value : felt):
    end
    func claim_points(my_value : felt):
    end
end

@contract_interface
namespace IEx03:
    func user_counters(account : felt) -> (user_counter : felt):
    end
    func decrement_counter():
    end
    func increment_counter():
    end
    func claim_points():
    end
end

@contract_interface
namespace IEx04:
    func assign_user_slot():
    end
    func user_slots(account : felt) -> (user_slot : felt):
    end
    func values_mapped(slot : felt) -> (value : felt):
    end
    func claim_points(expected_value : felt):
    end
    func set_random_values(values_len : felt, values : felt*):
    end
end

@contract_interface
namespace IEx05:
    func assign_user_slot():
    end
    func copy_secret_value_to_readable_mapping():
    end
    func user_values(account : felt) -> (user_value : felt):
    end
    func claim_points(expected_value : felt):
    end
    func set_random_values(values_len : felt, values : felt*):
    end
end

@contract_interface
namespace IEx06:
    func assign_user_slot():
    end
    func external_handler_for_internal_function(a_value : felt):
    end
    func user_values(account : felt) -> (user_value : felt):
    end
    func claim_points(expected_value : felt):
    end
    func set_random_values(values_len : felt, values : felt*):
    end
end

@contract_interface
namespace IEx07:
    func claim_points(value_a : felt, value_b : felt):
    end
end

@contract_interface
namespace IEx08:
    func set_user_values(account : felt, array_len : felt, array : felt*):
    end
    func claim_points():
    end
end

@contract_interface
namespace IEx09:
    func claim_points(array_len : felt, array : felt*):
    end
end

@contract_interface
namespace IEx10:
    func ex10b_address() -> (ex10b_address : felt):
    end
    func claim_points(secret_value_i_guess : felt, next_secret_value_i_chose : felt):
    end
end

@contract_interface
namespace IEx10b:
    func secret_value() -> (secret_value : felt):
    end
end

@contract_interface
namespace IEx11:
    func validate_answers(
    sender_address : felt, secret_value_i_guess : felt, next_secret_value_i_chose : felt):
    end
    func secret_value() -> (secret_value : felt):
    end
    func claim_points(
    secret_value_i_guess : felt, next_secret_value_i_chose : felt):
    end
end

@contract_interface
namespace IEx12:
    func assign_user_slot():
    end
    func claim_points(expected_value : felt):
    end
end

@contract_interface
namespace IEx13:
    func assign_user_slot():
    end
    func claim_points(expected_value : felt):
    end
end

@contract_interface
namespace IEx14:
    func claim_points():
    end
end