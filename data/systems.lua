local STAR_SYSTEMS = {}

STAR_SYSTEMS["Sol"] = {
    objects = {
        {
            class = "Planet", 
            data = {
                name  ="Earth", 
                x = 0, 
                y = 0
            }
        },
        {
            class = "Planet", 
            data = {
                name  = "Mars", 
                x = 200, 
                y = 200
            }
        },
    },
}

return STAR_SYSTEMS