minetest.register_on_generated(function(minp, maxp, seed)
    local manip = minetest.get_voxel_manip()
    local e1, e2 = manip:read_from_map(minp, maxp)
    local area = VoxelArea:new({MinEdge = e1, MaxEdge = e2})
    local data = manip:get_data())

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

local hills_offset = np_hills.spread.x*0.5
local hills_thresh = floor((np_terrain.scale)*0.5)
local shelf_thresh = floor((np_terrain.scale)*0.5) 
local cliffs_thresh=10
	
	local function max_height(noiseprm)
	local height = 0
	local scale = noiseprm.scale
	for i=1,noiseprm.octaves do
		height=height + scale
		scale = scale * noiseprm.persist
	end	
	return height+noiseprm.offset
	end
		local function min_height(noiseprm)
	local height = 0
	local scale = noiseprm.scale
	for i=1,noiseprm.octaves do
		height=height - scale
		scale = scale * noiseprm.persist
	end	
	return height+noiseprm.offset
end

local base_min = min_height(np_terrain)
local base_max = max_height(np_terrain)
local base_rng = base_max-base_min
local easing_factor = 1/(base_max*base_max*4)
local base_heightmap = {}
local result_heightmap = {}

	minetest.set_mapgen_setting('mg_name','singlenode',true)
minetest.set_mapgen_setting('flags','nolight',true)

local c_stone = minetest.get_content_id("default:stone")
local c_sand = minetest.get_content_id("default:sand")
local c_dirt = minetest.get_content_id("default:dirt")
local c_dirt_g = minetest.get_content_id("default:dirt_with_grass")
local c_dirt_l = minetest.get_content_id("default:dirt_with_rainforest_litter")
local c_snow = minetest.get_content_id("default:snowblock")
local c_water = minetest.get_content_id("default:water_source")

local function get_terrain_height(theight,hheight,cheight)
		-- parabolic gradient
	if theight > 0 and theight < shelf_thresh then
		theight = theight * (theight*theight/(shelf_thresh*shelf_thresh)*0.5 + 0.5)
	end	
		-- hills
	if theight > hills_thresh then
		theight = theight + max((theight-hills_thresh) * hheight,0)
		-- cliffs
	elseif theight > 1 and theight < hills_thresh then 
		local clifh = max(min(cheight,1),0) 
		if clifh > 0 then
			clifh = -1*(clifh-1)*(clifh-1) + 1
			theight = theight + (hills_thresh-theight) * clifh * ((theight<2) and theight-1 or 1)
		end
	end
	return theight
end

minetest.register_on_generated(function(minp, maxp, seed)

local t0 = os.clock()
local sidelen = maxp.x - minp.x + 1
local permapdims3d = {x = sidelen, y = sidelen, z = 0}

nobj_terrain = nobj_terrain or
		minetest.get_perlin_map(np_terrain, permapdims3d)		
	isln_terrain=nobj_terrain:get_2d_map({x=minp.x,y=minp.z})

nobj_var = nobj_var or
		minetest.get_perlin_map(np_var, permapdims3d)		
	isln_var=nobj_var:get_2d_map({x=minp.x,y=minp.z})

	nobj_hills = nobj_hills or
		minetest.get_perlin_map(np_hills, permapdims3d)
	isln_hills=nobj_hills:get_2d_map({x=minp.x+hills_offset,y=minp.z+hills_offset})

obj_cliffs = nobj_cliffs or
		minetest.get_perlin_map(np_cliffs, permapdims3d)
	isln_cliffs=nobj_cliffs:get_2d_map({x=minp.x,y=minp.z})


	nobj_trees = nobj_trees or
		minetest.get_perlin_map(np_trees, permapdims3d)
	isln_trees=nobj_trees:get_2d_map({x=minp.x,y=minp.z})

	end

minetest.register_on_newplayer(function(obj)
	local nobj_terrain = minetest.get_perlin_map(np_terrain, {x=1,y=1,z=0})	
	local nobj_hills = minetest.get_perlin_map(np_hills, {x=1,y=1,z=0})	
	local nobj_cliffs = minetest.get_perlin_map(np_cliffs, {x=1,y=1,z=0})	
	local th=nobj_terrain:get_2d_map({x=1,y=1})
	local hh=nobj_hills:get_2d_map({x=1,y=1})
	local ch=nobj_cliffs:get_2d_map({x=1,y=1})
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

