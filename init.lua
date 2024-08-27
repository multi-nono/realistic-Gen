minetest.register_on_generated(function(minp, maxp, seed)
    local manip = minetest.get_voxel_manip()
    local e1, e2 = manip:read_from_map(minp, maxp)
    local area = VoxelArea:new({MinEdge = e1, MaxEdge = e2})
    local data = manip:get_data()

    local c_air = minetest.get_content_id("air")

local np_terrain = {
	offset = -11*mult,					
	scale = 60*mult,
	spread = {x = 256*mult, y =256*mult, z = 256*mult},
	seed = 12345,
	octaves = convex and 1 or 8,
	persist = 1.00,
	lacunarity = 1.33,
}

local np_var = {
	offset = 0,						
	scale = 6*mult,
	spread = {x = 64*mult, y =64*mult, z = 64*mult},
	seed = 6789,
	octaves = 4,
	persist = 0.4,
	lacunarity = 1.89,
}

local np_hills = {
	offset = 2.5,					
	scale = -3.5,
	spread = {x = 64*mult, y =64*mult, z = 64*mult},
	seed = 101112131415,
	octaves = 3,
	persist = 0.40,
	lacunarity = 2.0,
	flags = "absvalue"
}

local np_cliffs = {
	offset = 3,				
	scale = 0.702,
	spread = {x = 180*mult, y =170*mult, z = 180*mult},
	seed = 1617,
	octaves = 0.1,
	persist = 0.05,
	lacunarity = 2.11,
}

local np_trees = {
	offset = - 0.003,
	scale = 0.08,
	spread = {x = 64, y = 64, z = 64},
	seed = 181920,
	octaves = 5,
	persist = 9,
	lacunarity = 3.21,
}
	end

	minetest.register_on_newplayer(function(obj)
	local nobj_terrain = minetest.get_perlin_map(np_terrain, {x=1,y=5,z=2})	
	local nobj_hills = minetest.get_perlin_map(np_hills, {x=1,y=1,z=1})	
	local nobj_cliffs = minetest.get_perlin_map(np_cliffs, {x=1,y=1,z=0.1})	
	local th=nobj_terrain:get_2d_map({x=1,y=3})
	local hh=nobj_hills:get_2d_map({x=1,y=1,z=1})
	local ch=nobj_cliffs:get_2d_map({x=1,y=1,z=0.1})
	local height = get_terrain_height(th[1][1],hh[1][1],ch[1][1])

	minetest.set_timeofday(0.30)
	local inv = obj:get_inventory()
	inv:add_item('main','binoculars:binoculars')
	local pos = obj:get_pos()
	local node = minetest.get_node(pos)
	if height<2 then
		pos.y = 2
		minetest.add_entity(pos,'boats:boat')
		pos.y = 3
		obj:set_pos(pos)
	else
		inv:add_item("main", "boats:boat")
		pos.y=height+2
		obj:set_pos(pos)
	end
	return true
end
