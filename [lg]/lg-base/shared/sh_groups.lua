--[[
    The higher the permissionlevel the more power the group has.

    If an admin wanted to add the owner rank to itself, it would be denied as the permission level is greater than admins.

    If you have no clue on what the fuck you are doing, do not touch this.
]]
LG.Groups = {
    ['owner'] = {
        admin = true,
        job = false,
        permissionlevel = 100
    },

    ['admin'] = {
        admin = true,
        job = false,
        permissionlevel = 50
    },

    ['moderator'] = {
        admin = true,
        job = false,
        permissionlevel = 25
    },

    ['user'] = {
        admin = false,
        job = false,
        permissionlevel = 0
    },

    ['unemployed'] = {
        admin = false,
        job = true,
    },
}
CreateThread(function()
    addComponent('Groups', LG.Groups)
end)