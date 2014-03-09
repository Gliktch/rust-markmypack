PLUGIN.Title = "Mark My Pack"
PLUGIN.Description = "(Experimental) Marks your death location with a Wood Storage Box, to make it easier to find your body & pack."
PLUGIN.Author = "Gliktch"
PLUGIN.Version = "0.3"

function PLUGIN:Init()
    self:AddChatCommand("box", self.cmdBox)
end

function PLUGIN:MarkSpot( netuser, x, y, z )
    print("testing box...")
    local spawn = util.FindOverloadedMethod( Rust.NetCull._type, "InstantiateStatic", bf.public_static, { System.String, UnityEngine.Vector3, UnityEngine.Quaternion } )
    print("MMP: spawn var is " .. tostring(spawn))
    local v = new(UnityEngine.Vector3)
    print("MMP: v var is " .. tostring(v))
    local q = new(UnityEngine.Quaternion)
    print("MMP: q var is " .. tostring(q))
    -- Location of object in map
    v.x = x
    print("MMP: x var is " .. tostring(x))
    print("MMP: v.x var is " .. tostring(v.x))
    v.y = ( y - 2 )
    print("MMP: y var is " .. tostring(y))
    print("MMP: v.y var is " .. tostring(v.y))
    v.z = z
    print("MMP: z var is " .. tostring(z))
    print("MMP: v.z var is " .. tostring(v.z))
    local slant = util.GetStaticMethod( UnityEngine.Quaternion._type, "LookRotation" )
    print("MMP: slant var is " .. tostring(slant))
    q = slant[1]:Invoke( nil, util.ArrayFromTable( cs.gettype( "System.Object" ), { v } ) )
    print("MMP: q var is " .. tostring(q))
    if spawn == nil then
        print("find overload failed")
        return false
    else
        print("find overload successful")
    end
    -- alternative marker items
    -- ;sleeper_male
    -- ;deploy_camp_bonfire
    -- ;explosive_charge
    -- ;struct_wooden_pillar
    -- ;struct_metal_pillar
    local marker = ";deploy_wood_box";
    local arr = util.ArrayFromTable( cs.gettype( "System.Object" ), { marker, v, q } );
    print("MMP: arr is " .. tostring(arr))
    cs.convertandsetonarray( arr, 0, marker, System.String._type )
    print("MMP: arr 0 is " .. tostring(arr))
    cs.convertandsetonarray( arr, 1, v, UnityEngine.Vector3._type )
    print("MMP: arr 1 is " .. tostring(arr))
    cs.convertandsetonarray( arr, 2, q, UnityEngine.Quaternion._type )
    print("MMP: arr 2 is " .. tostring(arr))
    local spawnBox = spawn:Invoke( nil, arr )
    print("MMP: spawnbox is " .. tostring(spawnbox))
    print("invoke end")
end

function PLUGIN:cmdBox( netuser, cmd, args )
    print("box command running...")
    local coords = netuser.playerClient.lastKnownPosition;
    print("coords: " .. tostring(coords))
    self.MarkSpot( netuser, "dummy", coords.x, coords.y, coords.z )
    print("should be a box now...")
    rust.SendChatToUser( netuser, "Ermagerd, berx!" )
end
