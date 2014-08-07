local STAR_SYSTEMS = {}

STAR_SYSTEMS["Sol"] = {
    x = 0,
    y = 0,

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
                x = 600, 
                y = 400
            }
        },
    },
}

STAR_SYSTEMS["Proxima Centauri"] = {
    x = 250,
    y = -200,

    objects = {
        {
            class = "Planet",
            data = {
                name = "Belinov",
                x = 0,
                y = 0,
            }
        },
    },
}

STAR_SYSTEMS["Alpha Centauri"] = {
    x = -100,
    y = -250,

    objects = {}
}

STAR_SYSTEMS["Belith"] = {
    x = -200,
    y = 200,

    objects = {},
}

STAR_SYSTEMS["Shalim"] = {
    x = 400,
    y = 250,

    objects = {},
}

STAR_SYSTEMS["Alatar"] = {
    x = 280,
    y = 330,

    objects = {},
}


return STAR_SYSTEMS