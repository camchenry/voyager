local MISSIONS = {}

MISSIONS[1] = {
	name = 'Delivery',
	pay = 20000,
	desc = 'Take a package to Mars in the Sol system.',
	start = 'Earth',
	destination = 'Mars',
}

MISSIONS[2] = {
	name = 'Delivery',
	pay = 20000,
	desc = 'Take a package to Belinov in Proxima Centauri.',
	start = 'Earth',
	destination = 'Belinov',
}

MISSIONS[3] = {
	name = 'Delivery',
	pay = 20000,
	desc = 'I need someone to take this here package to Belinov in Proxima Centauri',
	start = 'Mars',
	destination = 'Belinov',
}

return MISSIONS