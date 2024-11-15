setTick(() => {
    const ped = PlayerPedId();
    if (IsPedArmed(ped, 6)) {
        DisableControlAction(1, 140, true);
        DisableControlAction(1, 141, true);
        DisableControlAction(1, 142, true);
    }
});
