local STAR_SYSTEMS = {}

STAR_SYSTEMS["Sol"] = {
    x = 0,
    y = 0,

    objects = {
        {
            class = "Planet", 
            data = {
                name  = "Earth", 
                x = 0, 
                y = 0,
				
				pointer = 'Earth.png'
            }
        },
        {
            class = "Planet", 
            data = {
                name  = "Mars", 
                x = 600, 
                y = 400,
				
				pointer = 'Mars.png'
            }
        },
		{
            class = "Planet", 
            data = {
                name  = "Pluto", 
                x = 1900, 
                y = -2400,
				
				pointer = 'Pluto.png'
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
				
				pointer = 'Belinov.png'
            }
        },
		{
            class = "Planet",
            data = {
                name = "Joliv",
                x = -700,
                y = 300,
				
				pointer = 'Joliv.png'
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

    objects = {
		{
            class = "Planet",
            data = {
                name = "Lokuri",
                x = -400,
                y = -1100,
				
				pointer = 'Lokuri.png'
            }
        },
	},
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