local np_terrain = {
	offset = -11*mult,						
	scale = 40*mult,
	spread = {x = 256*mult, y =256*mult, z = 256*mult},
	seed = 2,
	octaves = convex and 1 or 8,
	persist = 1.00,
	lacunarity = 1.33,
}

ocal np_var = {
	offset = 0,						
	scale = 6*mult,
	spread = {x = 64*mult, y =64*mult, z = 64*mult},
	seed = ,
	octaves = 4,
	persist = 0.4,
	lacunarity = 1.89,
}

local np_hills = {
	offset = 2.5,					
	scale = -3.5,
	spread = {x = 64*mult, y =64*mult, z = 64*mult},
--	spread = {x = 32, y =32, z = 32},
	seed = ,
	octaves = 3,
	persist = 0.40,
	lacunarity = 2.0,
	flags = "absvalue"
}

local np_cliffs = {
	offset = 3,					
	scale = 0.72,
	spread = {x = 180*mult, y =180*mult, z = 180*mult},
	seed = ,
	octaves = 2,
	persist = 0.4,
	lacunarity = 2.11,
}

local np_trees = {
	offset = - 0.003,
	scale = 0.008,
	spread = {x = 64, y = 64, z = 64},
	seed = ,
	octaves = 5,
	persist = 3,
	lacunarity = 3.21,
}
