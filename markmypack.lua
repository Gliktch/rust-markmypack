PLUGIN.Title = "Mark My Pack"
PLUGIN.Description = "Marks your death location with a Wood Storage Box or other item, to make it easier to find your body & pack."
PLUGIN.Author = "Gliktch"
PLUGIN.Version = "0.3.1"

function PLUGIN:Init()
    self:AddChatCommand("mark", self.cmdMark)
end

function PLUGIN:MarkSpot( netuser, x, y, z )
    local spawn = util.FindOverloadedMethod( Rust.NetCull._type, "InstantiateStatic", bf.public_static, { System.String, UnityEngine.Vector3, UnityEngine.Quaternion } )
    local v = new(UnityEngine.Vector3)
    local q = new(UnityEngine.Quaternion)
    -- Location of object in map
    v.x = x
    v.y = ( y - 1.7 )
    v.z = z
    local slant = util.GetStaticMethod( UnityEngine.Quaternion._type, "LookRotation" )
    q = slant[1]:Invoke( nil, util.ArrayFromTable( cs.gettype( "System.Object" ), { v } ) )
    if spawn == nil then
        error("Mark My Pack: Failed to find overload!")
        return false
    end
    -- alternative marker items
    -- ;sleeper_male
    -- ;deploy_camp_bonfire
    -- ;explosive_charge
    -- ;struct_wooden_pillar
    -- ;struct_metal_pillar
    -- ;deploy_wood_box
    local marker = ";sleeper_male";
    local arr = util.ArrayFromTable( cs.gettype( "System.Object" ), { marker, v, q } );
    cs.convertandsetonarray( arr, 0, marker, System.String._type )
    cs.convertandsetonarray( arr, 1, v, UnityEngine.Vector3._type )
    cs.convertandsetonarray( arr, 2, q, UnityEngine.Quaternion._type )
    local spawnMarker = spawn:Invoke( nil, arr )
end

function PLUGIN:cmdMark( netuser, cmd, args )
    local coords = netuser.playerClient.lastKnownPosition;
    self.MarkSpot( netuser, "dummy", coords.x, coords.y, coords.z )
    rust.SendChatToUser( netuser, "Ermagerd, berx!" )
end
