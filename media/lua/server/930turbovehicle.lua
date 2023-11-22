--***Adapted from KI5/bikinihorst***

930turbo = {
    parts = {
        FrontBumper = {
            930turboFrontBumper {
                FrontBumper0 = "boltz_930turboFrontBumper0",
                FrontBumperA = "boltz_930turboFrontBumperA",
            },
            default = "first",
        },
        WindshieldArmor = {
            930turboWindshieldArmor = {
                930turbowinda = "boltz_930turboWinshieldArmor",
            },
        },
        WindowLeftArmor = {
            930turboWindowLeftArmor = {
                930turboleftwindowa = "boltz_930turboWindowArmor",
            },
        },
        WindowRightArmor = {
            930turboWindowRightArmor = {
                930turborightwindowa = "boltz_930turboWindowArmor",
            },
        },
        WindshieldRearArmor = {
            930turboWindshieldRearArmor = {
                930turbowindra = "boltz_930turboWindshieldRearArmor",
            },
        },
        RearBumper = {
            930turboRearBumper = {
                RearBumper0 = "boltz_930turboRearBumper0",
                RearbumperA = "boltz_930turboRearBumperA",
            },
            default = "first",
        },
        TireFrontLeft = {
            TireFrontLeft = {
                930turboTire = "boltz_930turboTire1",
            },
        },
        TireFrontRight = {
            TireFrontRight = {
                930turboTire = "boltz_930turboTire1",
            },
        },
        TireRearLeft = {
            TireRearLeft = {
                930turboTire = "boltz_930turboTire1",
            },
        },
        TireRearRight = {
            TireRearRight = {
                930turboTire = "boltz_930turboTire1",
            },
        },
    },
};

BOLTZ:createVehicleConfig(930turbo);

function 930turbo.ContainerAccess.Roofrack(vehicle, part, chr)
    if chr:getVehicle() then return false end
    if not vehicle:isInArea(part:getArea(), chr) then return false end
    return true
end