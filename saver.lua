--!native
--!optimize 2
--!divine-intellect
-- Universal SaveInstance (Optimized & Cleaned)

local function string_find(s, pattern)
	return string.find(s, pattern, nil, true)
end

local function ArrayToDict(t, hydridMode, valueOverride, typeStrict)
	local tmp = {}
	if hydridMode then
		for any1, any2 in t do
			if type(any1) == "number" then
				tmp[any2] = valueOverride or true
			elseif type(any2) == "table" then
				tmp[any1] = ArrayToDict(any2, hydridMode)
			else
				tmp[any1] = any2
			end
		end
	else
		for _, key in t do
			if not typeStrict or (typeStrict and type(key) == typeStrict) then
				tmp[key] = true
			end
		end
	end
	return tmp
end

local global_container
do
	local filename = "UniversalMethodFinder"
	local finder
	finder, global_container = loadstring(
		game:HttpGet("https://raw.githubusercontent.com/luau/SomeHub/main/" .. filename .. ".luau", true),
		filename
	)()

	finder({
		base64encode = 'local a={...}local b=a[1]local function c(a,b)return string.find(a,b,nil,true)end;return c(b,"encode")and(c(b,"base64")or c(string.lower(tostring(a[2])),"base64"))',
		gethiddenproperty = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"prop",nil,true) and string.sub(...,#...) ~= "s"',
		gethui = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"ui",nil,true)',
		getnilinstances = 'string.find(...,"nil",nil,true) and string.find(...,"get",nil,true) and string.sub(...,#...) == "s"',
		getscriptbytecode = 'string.find(...,"get",nil,true) and string.find(...,"script",nil,true) and string.find(...,"bytecode",nil,true)',
		protectgui = 'string.find(...,"protect",nil,true) and string.find(...,"ui",nil,true) and not string.find(...,"un",nil,true)',
	}, true, 10)
end

local identify_executor = identifyexecutor or getexecutorname or whatexecutor
local EXECUTOR_NAME = identify_executor and identify_executor() or ""

local gethiddenproperty = global_container.gethiddenproperty
local getscriptbytecode = global_container.getscriptbytecode
local base64encode = global_container.base64encode

local appendfile = appendfile
local isfile = isfile
local readfile = readfile
local writefile = writefile

local service = setmetatable({}, {
	__index = function(self, serviceName)
		local o, s = pcall(Instance.new, serviceName)
		local Service = (o and s) or game:GetService(serviceName) or settings():GetService(serviceName) or UserSettings():GetService(serviceName)
		if Service then self[serviceName] = Service end
		return Service
	end,
})

local SharedString_identifier = 1e15
local SharedStrings = setmetatable({}, {
	__index = function(self, str)
		local identifier = base64encode(tostring(SharedString_identifier))
		SharedString_identifier += 1
		self[str] = identifier
		return identifier
	end,
})

local inherited_properties = {}
local default_instances = {}
local referents, ref_size = {}, 0

local function GetRef(instance)
	local ref = referents[instance]
	if not ref then
		ref = ref_size
		referents[instance] = ref
		ref_size += 1
	end
	return ref
end

local function index(self, index_name)
	return self[index_name]
end

local FULL_VERSION
if not pcall(function() FULL_VERSION = version() end) then
	if not pcall(function() FULL_VERSION = settings():GetService("DebugSettings").RobloxVersion end) then
		if not pcall(function() FULL_VERSION = service.RunService:GetRobloxVersion() end) then
			FULL_VERSION = "UNKNOWN"
		end
	end
end

local CLIENT_VERSION = tonumber(string.match(FULL_VERSION, "%d+%.(%d+)")) or 9e9

local attr_Type_IDs = {
	string = 0x02, boolean = 0x03, int32 = 0x04, number = 0x06, UDim = 0x09, UDim2 = 0x0A,
	Ray = 0x0B, Faces = 0x0C, Axes = 0x0D, BrickColor = 0x0E, Color3 = 0x0F, Vector2 = 0x10,
	Vector3 = 0x11, Vector2int16 = 0x12, Vector3int16 = 0x13, CFrame = 0x14, EnumItem = 0x15,
	NumberSequence = 0x17, NumberSequenceKeypoint = 0x18, ColorSequence = 0x19, ColorSequenceKeypoint = 0x1A,
	NumberRange = 0x1B, Rect = 0x1C, PhysicalProperties = 0x1D, Region3 = 0x1F, Region3int16 = 0x20,
	Font = 0x21, SecurityCapabilities = 0x22, Path2DControlPoint = 0x23,
}

local CFrame_Rotation_IDs = {
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x02,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x03,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x05,
	["\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x06,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x07,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x09,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x0a,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x0c,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0d,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0e,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x10,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128"] = 0x11,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x14,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128"] = 0x15,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x17,
	["\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128"] = 0x18,
	["\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x19,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x1b,
	["\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x1c,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x1e,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x1f,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x20,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x22,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128"] = 0x23,
}

local BASE_CAPABILITIES
pcall(function() BASE_CAPABILITIES = SecurityCapabilities.new() end)

local CAPABILITY_BITS = {
	Plugin = 2 ^ 0, LocalUser = 2 ^ 1, WritePlayer = 2 ^ 2, RobloxScript = 2 ^ 3, RobloxEngine = 2 ^ 4, NotAccessible = 2 ^ 5,
	RunClientScript = 2 ^ 8, RunServerScript = 2 ^ 9, Unknown = 2 ^ 10, AccessOutsideWrite = 2 ^ 11,
	Unassigned = 2 ^ 15, LoadUnownedAsset = 2 ^ 16, LoadString = 2 ^ 17, ScriptGlobals = 2 ^ 18, CreateInstances = 2 ^ 19,
	Basic = 2 ^ 20, Audio = 2 ^ 21, DataStore = 2 ^ 22, Network = 2 ^ 23, Physics = 2 ^ 24, UI = 2 ^ 25, CSG = 2 ^ 26,
	Chat = 2 ^ 27, Animation = 2 ^ 28, AvatarAppearance = 2 ^ 29, Input = 2 ^ 30, Environment = 2 ^ 31, RemoteEvent = 2 ^ 32,
	LegacySound = 2 ^ 33, Players = 2 ^ 34, CapabilityControl = 2 ^ 35, AssetRead = 2 ^ 36, AssetManagement = 2 ^ 37,
	DynamicGeneration = 2 ^ 38, PlatformAvatarEditing = 2 ^ 39, AssetCreateUpdate = 2 ^ 40, Capture = 2 ^ 41, SensitiveInput = 2 ^ 42,
	Monetization = 2 ^ 43, LoadOwnedAsset = 2 ^ 44, Social = 2 ^ 45, ServerCommunication = 2 ^ 46, Logging = 2 ^ 47,
	PromptExternalPurchase = 2 ^ 48, Groups = 2 ^ 49, Teleport = 2 ^ 50, Consequences = 2 ^ 51, Material = 2 ^ 52, AvatarBehavior = 2 ^ 53,
	RemoteCommand = 2 ^ 59, InternalTest = 2 ^ 60, PluginOrOpenCloud = 2 ^ 61, Assistant = 2 ^ 62, Restricted = 2 ^ 63,
}

local function __COUNT_CAPABILITY_BITS(raw)
	local result = 0
	for _, flag in string.split(tostring(raw), " | ") do
		local bit = CAPABILITY_BITS[flag]
		if bit then result += bit end
	end
	return result
end

local function __COUNT_BITS(...)
	local Value = 0
	for i, bit in { ... } do
		if bit then Value += 2 ^ (i - 1) end
	end
	return Value
end

local Binary_Descriptors
Binary_Descriptors = {
	__PACK_MULTIPLE = function(descriptor, value1, value2, value3)
		local buf1, size1 = descriptor(value1)
		local buf2, size2 = descriptor(value2)
		local len = size1 + size2
		local buf3, size3

		if value3 ~= nil then
			buf3, size3 = descriptor(value3)
			len += size3
		end

		local b = buffer.create(len)
		buffer.copy(b, 0, buf1)
		buffer.copy(b, size1, buf2)
		if value3 ~= nil then buffer.copy(b, size1 + size2, buf3) end
		return b, len
	end,
	__construct_Sequence = function(keypoint_handler, keypointSize)
		return function(raw)
			local Keypoints = raw.Keypoints
			local Keypoints_n = #Keypoints
			local len = 4 + keypointSize * Keypoints_n
			local b = buffer.create(len)
			buffer.writeu32(b, 0, Keypoints_n)

			local offset = 4
			for _, keypoint in Keypoints do
				keypoint_handler(keypoint, b, offset)
				offset += keypointSize
			end
			return b, len
		end
	end,
	__writei64 = function(b, offset, raw)
		local low = bit32.band(raw, 0xFFFFFFFF)
		local high = (raw - low) / 0x100000000
		buffer.writei32(b, offset, low)
		buffer.writei32(b, offset + 4, high)
	end,
	__construct__PACKER = function(float)
		local writeFunc = float and buffer.writef32 or buffer.writei16
		local elementSize = float and 4 or 2
		return function(X, Y, Z)
			local len = Z and (elementSize * 3) or (elementSize * 2)
			local b = buffer.create(len)
			writeFunc(b, 0, X)
			writeFunc(b, elementSize, Y)
			if Z then writeFunc(b, elementSize * 2, Z) end
			return b, len
		end
	end,
	["string"] = function(raw)
		local raw_len = #raw
		local len = 4 + raw_len
		local b = buffer.create(len)
		buffer.writeu32(b, 0, raw_len)
		buffer.writestring(b, 4, raw)
		return b, len
	end,
	["boolean"] = function(raw)
		local b = buffer.create(1)
		buffer.writeu8(b, 0, raw and 1 or 0)
		return b, 1
	end,
	["number"] = function(raw)
		local b = buffer.create(8)
		buffer.writef64(b, 0, raw)
		return b, 8
	end,
	["UDim"] = function(raw)
		local b = buffer.create(8)
		buffer.writef32(b, 0, raw.Scale)
		buffer.writei32(b, 4, raw.Offset)
		return b, 8
	end,
	["UDim2"] = function(raw) return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["UDim"], raw.X, raw.Y) end,
	["Ray"] = function(raw) return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["Vector3"], raw.Origin, raw.Direction) end,
	["Faces"] = function(raw)
		local b = buffer.create(4)
		buffer.writeu32(b, 0, __COUNT_BITS(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front))
		return b, 4
	end,
	["Axes"] = function(raw)
		local b = buffer.create(4)
		buffer.writeu32(b, 0, __COUNT_BITS(raw.X, raw.Y, raw.Z))
		return b, 4
	end,
	["BrickColor"] = function(raw)
		local b = buffer.create(4)
		buffer.writeu32(b, 0, raw.Number)
		return b, 4
	end,
	["Color3"] = function(raw) return Binary_Descriptors.__PACK_F32(raw.R, raw.G, raw.B) end,
	["Vector2"] = function(raw) return Binary_Descriptors.__PACK_F32(raw.X, raw.Y) end,
	["Vector3"] = function(raw) return Binary_Descriptors.__PACK_F32(raw.X, raw.Y, raw.Z) end,
	["Vector2int16"] = function(raw) return Binary_Descriptors.__PACK_I16(raw.X, raw.Y) end,
	["Vector3int16"] = function(raw) return Binary_Descriptors.__PACK_I16(raw.X, raw.Y, raw.Z) end,
	["CFrame"] = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()
		local rotation_ID
		do
			local b = buffer.create(36)
			buffer.writef32(b, 0, R00); buffer.writef32(b, 4, R01); buffer.writef32(b, 8, R02)
			buffer.writef32(b, 12, R10); buffer.writef32(b, 16, R11); buffer.writef32(b, 20, R12)
			buffer.writef32(b, 24, R20); buffer.writef32(b, 28, R21); buffer.writef32(b, 32, R22)
			rotation_ID = CFrame_Rotation_IDs[buffer.tostring(b)]
		end

		local len = rotation_ID and 13 or 49
		local b = buffer.create(len)
		local __PACK_F32 = Binary_Descriptors.__PACK_F32
		
		buffer.copy(b, 0, __PACK_F32(X, Y, Z))

		if rotation_ID then
			buffer.writeu8(b, 12, rotation_ID)
		else
			buffer.writeu8(b, 12, 0x0)
			buffer.copy(b, 13, __PACK_F32(R00, R01, R02))
			buffer.copy(b, 25, __PACK_F32(R10, R11, R12))
			buffer.copy(b, 37, __PACK_F32(R20, R21, R22))
		end
		return b, len
	end,
	["EnumItem"] = function(raw)
		local b_Name, Name_size = Binary_Descriptors["string"](tostring(raw.EnumType))
		local len = Name_size + 4
		local b = buffer.create(len)
		buffer.copy(b, 0, b_Name)
		buffer.writeu32(b, Name_size, raw.Value)
		return b, len
	end,
	["NumberSequenceKeypoint"] = function(keypoint, b, offset)
		if not b then return Binary_Descriptors.__PACK_F32(keypoint.Envelope, keypoint.Time, keypoint.Value) end
		buffer.writef32(b, offset, keypoint.Envelope)
		buffer.writef32(b, offset + 4, keypoint.Time)
		buffer.writef32(b, offset + 8, keypoint.Value)
	end,
	["ColorSequenceKeypoint"] = function(keypoint, b, offset)
		local Value = Binary_Descriptors["Color3"](keypoint.Value)
		if not b then
			b = buffer.create(20)
			offset = 0
		end
		buffer.writef32(b, offset, 0)
		buffer.writef32(b, offset + 4, keypoint.Time)
		buffer.copy(b, offset + 8, Value)
		return b, 20
	end,
	["NumberRange"] = function(raw) return Binary_Descriptors.__PACK_F32(raw.Min, raw.Max) end,
	["Rect"] = function(raw) return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["Vector2"], raw.Min, raw.Max) end,
	["PhysicalProperties"] = function(raw)
		local len = raw and 25 or 1
		local b = buffer.create(len)
		buffer.writeu8(b, 0, raw and 3 or 0)
		if raw then
			buffer.writef32(b, 1, raw.Density)
			buffer.writef32(b, 5, raw.Friction)
			buffer.writef32(b, 9, raw.Elasticity)
			buffer.writef32(b, 13, raw.FrictionWeight)
			buffer.writef32(b, 17, raw.ElasticityWeight)
			buffer.writef32(b, 21, raw.AcousticAbsorption)
		end
		return b, len
	end,
	["Region3"] = function(raw)
		local Trans = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5
		return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["Vector3"], Trans - HalfSize, Trans + HalfSize)
	end,
	["Region3int16"] = function(raw) return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["Vector3int16"], raw.Min, raw.Max) end,
	["Font"] = function(raw)
		local string__descriptor = Binary_Descriptors["string"]
		local b_Family, Family_size = string__descriptor(raw.Family)
		local b_CachedFaceId, CachedFaceId_size = string__descriptor("")
		local len = 3 + Family_size + CachedFaceId_size
		local b = buffer.create(len)
		local ok_w, weight = pcall(index, raw, "Weight")
		local ok_s, style = pcall(index, raw, "Style")
		buffer.writeu16(b, 0, ok_w and weight.Value or 0)
		buffer.writeu8(b, 2, ok_s and style.Value or 0)
		buffer.copy(b, 3, b_Family)
		buffer.copy(b, 3 + Family_size, b_CachedFaceId)
		return b, len
	end,
	["SecurityCapabilities"] = function(raw)
		local b = buffer.create(8)
		if raw == BASE_CAPABILITIES then return b, 8 end
		Binary_Descriptors.__writei64(b, 0, __COUNT_CAPABILITY_BITS(raw))
		return b, 8
	end,
	["Path2DControlPoint"] = function(raw) return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["UDim2"], raw.Position, raw.LeftTangent, raw.RightTangent) end,
}

Binary_Descriptors["NumberSequence"] = Binary_Descriptors.__construct_Sequence(Binary_Descriptors["NumberSequenceKeypoint"], 12)
Binary_Descriptors["ColorSequence"] = Binary_Descriptors.__construct_Sequence(Binary_Descriptors["ColorSequenceKeypoint"], 20)
Binary_Descriptors.__PACK_F32 = Binary_Descriptors.__construct__PACKER(true)
Binary_Descriptors.__PACK_I16 = Binary_Descriptors.__construct__PACKER()

local ESCAPES_PATTERN = "[&<>\"'\0\1-\9\11-\12\14-\31\127-\255]"
local ESCAPES = { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;", ['"'] = "&#34;", ["'"] = "&#39;", ["\0"] = "" }
for rangeStart, rangeEnd in string.gmatch(ESCAPES_PATTERN, "(.)%-(.)") do
	for charCode = string.byte(rangeStart), string.byte(rangeEnd) do
		ESCAPES[string.char(charCode)] = "&#" .. charCode .. ";"
	end
end

local XML_Descriptors
XML_Descriptors = {
	__CDATA = function(raw) return "<![CDATA[" .. raw .. "]]>" end,
	__NORMALIZE_NUMBER = function(raw)
		if raw ~= raw then return "NAN" elseif raw == math.huge then return "INF" elseif raw == -math.huge then return "-INF" end
		return raw
	end,
	__NORMALIZE_RANGE = function(raw) return raw ~= raw and "0" or raw end,
	__MINMAX = function(min, max, descriptor) return "<min>" .. descriptor(min) .. "</min><max>" .. descriptor(max) .. "</max>" end,
	__PROTECTEDSTRING = function(raw)
		return string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES) or XML_Descriptors.__CDATA(raw)
	end,
	__construct_Sequence = function(keypoint_handler)
		return function(raw)
			local sequence = ""
			for _, keypoint in raw.Keypoints do sequence ..= keypoint_handler(keypoint) end
			return sequence
		end
	end,
	__VECTOR = function(X, Y, Z)
		local Value = "<X>" .. X .. "</X><Y>" .. Y .. "</Y>"
		if Z then Value ..= "<Z>" .. Z .. "</Z>" end
		return Value
	end,
	Axes = function(raw) return "<axes>" .. __COUNT_BITS(raw.X, raw.Y, raw.Z) .. "</axes>" end,
	BinaryString = function(raw) return raw == "" and "" or base64encode(raw) end,
	BrickColor = function(raw) return raw.Number end,
	CFrame = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()
		return XML_Descriptors.__VECTOR(X, Y, Z) .. "<R00>" .. R00 .. "</R00><R01>" .. R01 .. "</R01><R02>" .. R02 .. "</R02><R10>" .. R10 .. "</R10><R11>" .. R11 .. "</R11><R12>" .. R12 .. "</R12><R20>" .. R20 .. "</R20><R21>" .. R21 .. "</R21><R22>" .. R22 .. "</R22>", "CoordinateFrame"
	end,
	Color3 = function(raw) return "<R>" .. raw.R .. "</R><G>" .. raw.G .. "</G><B>" .. raw.B .. "</B>" end,
	Color3uint8 = function(raw) return 0xFF000000 + (math.floor(raw.R * 255) * 0x10000) + (math.floor(raw.G * 255) * 0x100) + math.floor(raw.B * 255) end,
	ColorSequenceKeypoint = function(keypoint)
		local norm = XML_Descriptors.__NORMALIZE_RANGE
		return norm(keypoint.Time) .. " " .. norm(keypoint.Value.R) .. " " .. norm(keypoint.Value.G) .. " " .. norm(keypoint.Value.B) .. " 0 "
	end,
	Content = function(raw)
		local SourceType = raw.SourceType
		return SourceType == Enum.ContentSourceType.None and "<null></null>" or SourceType == Enum.ContentSourceType.Uri and "<uri>" .. XML_Descriptors.string(raw.Uri) .. "</uri>" or SourceType == Enum.ContentSourceType.Object and "<Ref>" .. GetRef(raw.Object) .. "</Ref>" or SourceType == Enum.ContentSourceType.Opaque and "<Ref>" .. GetRef(raw.Opaque) .. "</Ref>"
	end,
	ContentId = function(raw) return raw == "" and "<null></null>" or "<url>" .. XML_Descriptors.string(raw) .. "</url>", "Content" end,
	CoordinateFrame = function(raw) return "<CFrame>" .. XML_Descriptors.CFrame(raw) .. "</CFrame>" end,
	EnumItem = function(raw) return raw.Value, "token" end,
	Faces = function(raw) return "<faces>" .. __COUNT_BITS(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front) .. "</faces>" end,
	Font = function(raw)
		local ok_w, weight = pcall(index, raw, "Weight")
		local ok_s, style = pcall(index, raw, "Style")
		return "<Family>" .. XML_Descriptors.ContentId(raw.Family) .. "</Family><Weight>" .. (ok_w and XML_Descriptors.EnumItem(weight) or "") .. "</Weight><Style>" .. (ok_s and style.Name or "") .. "</Style>"
	end,
	NumberRange = function(raw) return XML_Descriptors.__NORMALIZE_RANGE(raw.Min) .. " " .. XML_Descriptors.__NORMALIZE_RANGE(raw.Max) end,
	NumberSequenceKeypoint = function(keypoint)
		local norm = XML_Descriptors.__NORMALIZE_RANGE
		return norm(keypoint.Time) .. " " .. norm(keypoint.Value) .. " " .. norm(keypoint.Envelope) .. " "
	end,
	PhysicalProperties = function(raw)
		local CustomPhysics = "<CustomPhysics>" .. XML_Descriptors.bool(raw and true or false) .. "</CustomPhysics>"
		return raw and CustomPhysics .. "<Density>" .. raw.Density .. "</Density><Friction>" .. raw.Friction .. "</Friction><Elasticity>" .. raw.Elasticity .. "</Elasticity><FrictionWeight>" .. raw.FrictionWeight .. "</FrictionWeight><ElasticityWeight>" .. raw.ElasticityWeight .. "</ElasticityWeight><AcousticAbsorption>" .. raw.AcousticAbsorption .. "</AcousticAbsorption>" or CustomPhysics
	end,
	Ray = function(raw) return "<origin>" .. XML_Descriptors.Vector3(raw.Origin) .. "</origin><direction>" .. XML_Descriptors.Vector3(raw.Direction) .. "</direction>" end,
	Rect = function(raw) return XML_Descriptors.__MINMAX(raw.Min, raw.Max, XML_Descriptors.Vector2), "Rect2D" end,
	Region3 = function(raw)
		local Trans = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5
		return XML_Descriptors.__MINMAX(Trans - HalfSize, Trans + HalfSize, XML_Descriptors.Vector3)
	end,
	Region3int16 = function(raw) return XML_Descriptors.__MINMAX(raw.Min, raw.Max, XML_Descriptors.Vector3int16) end,
	SharedString = function(raw) return SharedStrings[XML_Descriptors.BinaryString(raw)] end,
	SecurityCapabilities = function(raw) return raw == BASE_CAPABILITIES and 0 or __COUNT_CAPABILITY_BITS(raw) end,
	UDim = function(raw) return "<S>" .. raw.Scale .. "</S><O>" .. raw.Offset .. "</O>" end,
	UDim2 = function(raw) return "<XS>" .. raw.X.Scale .. "</XS><XO>" .. raw.X.Offset .. "</XO><YS>" .. raw.Y.Scale .. "</YS><YO>" .. raw.Y.Offset .. "</YO>" end,
	UniqueId = function(raw) return string.gsub(raw, "-", "") end,
	Vector2 = function(raw) return XML_Descriptors.__VECTOR(raw.X, raw.Y) end,
	Vector3 = function(raw) return XML_Descriptors.__VECTOR(raw.X, raw.Y, raw.Z) end,
	bool = function(raw) return raw and "true" or "false" end,
	string = function(raw)
		return (raw == nil or raw == "") and "" or string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES) or XML_Descriptors.__CDATA(string.gsub(raw, "\0", ""))
	end,
}

XML_Descriptors.NumberSequence = XML_Descriptors.__construct_Sequence(XML_Descriptors.NumberSequenceKeypoint)
XML_Descriptors.ColorSequence = XML_Descriptors.__construct_Sequence(XML_Descriptors.ColorSequenceKeypoint)

for dName, rName in { NetAssetRef = "SharedString", Vector2int16 = "Vector2", Vector3int16 = "Vector3", double = "__NORMALIZE_NUMBER", float = "__NORMALIZE_NUMBER", int = "__NORMALIZE_NUMBER", int64 = "__NORMALIZE_NUMBER" } do
	XML_Descriptors[dName] = XML_Descriptors[rName]
end

local ClassList, FetchAPI

do
	local ClassPropertyExceptions = ArrayToDict({
		Whitelist = { MeshPart = {"CollisionFidelity"}, PartOperation = {"CollisionFidelity"}, TriangleMeshPart = {"CollisionFidelity"} },
		Blacklist = { LuaSourceContainer = {"ScriptGuid"}, Instance = {"UniqueId", "HistoryId"} },
	}, true)

	local function AttributesSerialize(attrs)
		local attrs_n, buffer_size = 0, 4
		local attrs_sorted, attrs_formatted = {}, table.clone(attrs)
		for attr, val in attrs do
			attrs_n += 1
			attrs_sorted[attrs_n] = attr
			local attr_size
			attrs_formatted[attr], attr_size = Binary_Descriptors[typeof(val)](val)
			buffer_size += 5 + #attr + attr_size
		end
		table.sort(attrs_sorted)
		local b = buffer.create(buffer_size)
		buffer.writeu32(b, 0, attrs_n)
		local string__descriptor = Binary_Descriptors["string"]
		local offset = 4
		for _, attr in attrs_sorted do
			local b_Name, Name_size = string__descriptor(attr)
			buffer.copy(b, offset, b_Name)
			offset += Name_size
			buffer.writeu8(b, offset, attr_Type_IDs[typeof(attrs[attr])])
			offset += 1
			local bb = attrs_formatted[attr]
			buffer.copy(b, offset, bb)
			offset += buffer.len(bb)
		end
		return buffer.tostring(b)
	end

	local function AttenuationSerialize(attenuations)
		if not next(attenuations) then return "\0" end
		local attenuations_n, attenuations_sorted = 0, {}
		for key in attenuations do
			attenuations_n += 1; attenuations_sorted[attenuations_n] = key
		end
		table.sort(attenuations_sorted)
		local b = buffer.create(1 + attenuations_n * 8)
		local offset = 1
		for _, key in attenuations_sorted do
			buffer.writef32(b, offset, key)
			buffer.writef32(b, offset + 4, attenuations[key])
			offset += 8
		end
		return buffer.tostring(b)
	end

	local function TransformsSerialize(transforms)
		local transforms_n = #transforms
		if transforms_n == 0 then return "\1\0\0\0\0\0\0\0" end
		local b = buffer.create(8 + transforms_n * 48)
		buffer.writeu32(b, 0, 1)
		buffer.writeu32(b, 4, transforms_n)
		local offset = 8
		for _, t in transforms do
			local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = t:GetComponents()
			buffer.copy(b, offset, Binary_Descriptors.__PACK_F32(R00, R01, R02)); offset += 12
			buffer.copy(b, offset, Binary_Descriptors.__PACK_F32(R10, R11, R12)); offset += 12
			buffer.copy(b, offset, Binary_Descriptors.__PACK_F32(R20, R21, R22)); offset += 12
			buffer.copy(b, offset, Binary_Descriptors.__PACK_F32(X, Y, Z)); offset += 12
		end
		return buffer.tostring(b)
	end

	local NotScriptableFixes = {
		Instance = {
			AttributesSerialize = function(instance)
				local attrs = instance:GetAttributes()
				return next(attrs) and AttributesSerialize(attrs) or ""
			end,
			DefinesCapabilities = "Sandboxed",
			Tags = function(instance)
				local tags = service.CollectionService:GetTags(instance)
				return #tags > 0 and table.concat(tags, "\0") or ""
			end,
		},
		Path2D = {
			PropertiesSerialize = function(instance)
				local cp = instance:GetControlPoints()
				local cp_n = #cp
				if cp_n == 0 then return "\0\0\0\0" end
				local b = buffer.create(4 + cp_n * 49)
				buffer.writeu32(b, 0, cp_n)
				local offset = 4
				for _, point in cp do
					buffer.writeu8(b, offset, attr_Type_IDs["Path2DControlPoint"]); offset += 1
					buffer.copy(b, offset, Binary_Descriptors["Path2DControlPoint"](point)); offset += 48
				end
				return buffer.tostring(b)
			end,
		},
		PlayerEmulatorService = { SerializedEmulatedPolicyInfo = function(inst) return next(inst:GetEmulatedPolicyInfo()) and AttributesSerialize(inst:GetEmulatedPolicyInfo()) or "" end },
		StyleRule = { PropertiesSerialize = function(inst) return next(inst:GetProperties()) and AttributesSerialize(inst:GetProperties()) or "\0\0\0\0" end },
		StyleQuery = { ConditionsSerialize = function(inst) return next(inst:GetConditions()) and AttributesSerialize(inst:GetConditions()) or "\0\0\0\0" end },
		MarkerCurve = {
			ValuesAndTimes = function(instance)
				local markers = instance:GetMarkers()
				local m_n = #markers
				if m_n == 0 then return "\2\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0" end
				local strings_size = 0
				for _, m in markers do strings_size += #m.Value + 1 end
				local b = buffer.create(8 + strings_size + 8 + (m_n * 4))
				buffer.writeu32(b, 0, 2); buffer.writeu32(b, 4, m_n)
				local offset = 8
				for _, m in markers do
					buffer.writestring(b, offset, m.Value)
					offset += #m.Value + 1
				end
				buffer.writeu32(b, offset, 1); offset += 4
				buffer.writeu32(b, offset, m_n); offset += 4
				for _, m in markers do
					buffer.writeu32(b, offset, math.round(m.Time * 2400))
					offset += 4
				end
				return buffer.tostring(b)
			end,
		},
		AnimationClip = {
			GuidBinaryString = function(instance)
				local clean = string.gsub(instance.Guid, "[{}-]", "")
				local bytes = buffer.create(16)
				for i = 0, 15 do buffer.writeu8(bytes, i, tonumber(string.sub(clean, (i * 2) + 1, (i * 2) + 2), 16) or 0) end
				return buffer.tostring(bytes)
			end,
		},
		AnimationRigData = {
			label = function(instance)
				local labels = instance:GetLabels()
				if #labels == 0 then return "\1\0\0\0\0\0\0\0" end
				local b = buffer.create(8 + #labels * 4)
				buffer.writeu32(b, 0, 1); buffer.writeu32(b, 4, #labels)
				local offset = 8
				for _, l in labels do buffer.writeu32(b, offset, l); offset += 4 end
				return buffer.tostring(b)
			end,
			name = function(instance)
				local names = instance:GetNames()
				if #names == 0 then return "\1\0\0\0\0\0\0\0" end
				local b_size = 8
				for _, n in names do b_size += 4 + #n end
				local b = buffer.create(b_size)
				buffer.writeu32(b, 0, 1); buffer.writeu32(b, 4, #names)
				local offset = 8
				for _, n in names do buffer.writeu32(b, offset, #n); offset += 4 end
				for _, n in names do buffer.writestring(b, offset, n); offset += #n end
				return buffer.tostring(b)
			end,
			parent = function(instance)
				local parents = instance:GetParents()
				if #parents == 0 then return "\1\0\0\0\0\0\0\0" end
				local b = buffer.create(8 + #parents * 2)
				buffer.writeu32(b, 0, 1); buffer.writeu32(b, 4, #parents)
				local offset = 8
				for _, p in parents do buffer.writeu16(b, offset, p); offset += 2 end
				return buffer.tostring(b)
			end,
			postTransform = function(inst) return TransformsSerialize(inst:GetPostTransforms()) end,
			preTransform = function(inst) return TransformsSerialize(inst:GetPreTransforms()) end,
			transform = function(inst) return TransformsSerialize(inst:GetTransforms()) end,
		},
		AudioDeviceInput = {
			AccessList = function(instance)
				local uid = instance:GetUserIdAccessList()
				if #uid == 0 then return "" end
				local b = buffer.create(#uid * 8)
				local offset = 0
				for _, u in uid do Binary_Descriptors.__writei64(b, offset, u); offset += 8 end
				return buffer.tostring(b)
			end,
		},
		AudioEmitter = { AngleAttenuation = function(i) return AttenuationSerialize(i:GetAngleAttenuation()) end, DistanceAttenuation = function(i) return AttenuationSerialize(i:GetDistanceAttenuation()) end },
		AudioListener = { AngleAttenuation = function(i) return AttenuationSerialize(i:GetAngleAttenuation()) end, DistanceAttenuation = function(i) return AttenuationSerialize(i:GetDistanceAttenuation()) end },
		DebuggerBreakpoint = { line = "Line" },
		BallSocketConstraint = { MaxFrictionTorqueXml = "MaxFrictionTorque" },
		BasePart = { Color3uint8 = "Color", MaterialVariantSerialized = "MaterialVariant", size = "Size" },
		DoubleConstrainedValue = { value = "Value" }, IntConstrainedValue = { value = "Value" },
		CustomEvent = {
			PersistedCurrentValue = function(instance)
				local r = instance:GetAttachedReceivers()[1]
				if r then return r:GetCurrentValue() end
				local temp, clone = Instance.new("CustomEventReceiver"), Instance.fromExisting(instance)
				temp.Source = clone
				local v = temp:GetCurrentValue()
				temp:Destroy(); clone:Destroy()
				return v
			end,
		},
		Terrain = {
			AcquisitionMethod = "LastUsedModificationMethod",
			MaterialColors = function(instance)
				local mats = { Enum.Material.Grass, Enum.Material.Slate, Enum.Material.Concrete, Enum.Material.Brick, Enum.Material.Sand, Enum.Material.WoodPlanks, Enum.Material.Rock, Enum.Material.Glacier, Enum.Material.Snow, Enum.Material.Sandstone, Enum.Material.Mud, Enum.Material.Basalt, Enum.Material.Ground, Enum.Material.CrackedLava, Enum.Material.Asphalt, Enum.Material.Cobblestone, Enum.Material.Ice, Enum.Material.LeafyGrass, Enum.Material.Salt, Enum.Material.Limestone, Enum.Material.Pavement }
				local b = buffer.create(69)
				local offset = 6
				for _, mat in mats do
					local c = instance:GetMaterialColor(mat)
					buffer.writeu8(b, offset, math.floor(c.R * 255)); offset += 1
					buffer.writeu8(b, offset, math.floor(c.G * 255)); offset += 1
					buffer.writeu8(b, offset, math.floor(c.B * 255)); offset += 1
				end
				return buffer.tostring(b)
			end,
		},
		TriangleMeshPart = { FluidFidelityInternal = "FluidFidelity" },
		MeshPart = { InitialSize = "MeshSize" }, PartOperation = { InitialSize = "MeshSize" }, Part = { shape = "Shape" }, TrussPart = { style = "Style" }, FormFactorPart = { formFactorRaw = "FormFactor" },
		Fire = { heat_xml = "Heat", size_xml = "Size" },
		Humanoid = { Health_XML = "Health", InternalBodyScale = function(i) return i:GetAccessoryHandleScale(i.Parent.HumanoidRootPart, Enum.BodyPartR15.RootPart) end, InternalHeadScale = function(i) return i:GetAccessoryHandleScale(i.Parent.Head, Enum.BodyPartR15.Head).X end },
		HumanoidDescription = {
			EmotesDataInternal = function(i) local d=""; for n, id in i:GetEmotes() do d..=n.."^"..table.concat(id,"^").."^\\" end return d end,
			EquippedEmotesDataInternal = function(i) local d=""; for _, e in i:GetEquippedEmotes() do d..=e.Slot.."^"..e.Name.."\\" end return d end,
		},
		LocalizationTable = { Contents = function(i) return i:GetContents() end },
		MaterialService = { Use2022MaterialsXml = "Use2022Materials" },
		VideoPlayer = { PlayingReplicating = "IsPlaying" },
		Model = { ModelMeshCFrame = function(i) return i:GetModelCFrame() end, ModelMeshSize = function(i) return i:GetExtentsSize() end, Scale = function(i) return i:GetScale() end, ScaleFactor = function(i) return i:GetScale() end, WorldPivotData = "WorldPivot" },
		PackageLink = { PackageIdSerialize = "PackageId", VersionIdSerialize = "VersionNumber" },
		Players = { MaxPlayersInternal = "MaxPlayers", PreferredPlayersInternal = "PreferredPlayers" },
		StarterPlayer = { AvatarJointUpgrade_Serialized = "AvatarJointUpgrade" },
		Smoke = { size_xml = "Size", opacity_xml = "Opacity", riseVelocity_xml = "RiseVelocity" },
		Sound = { xmlRead_MinDistance_3 = "RollOffMinDistance", xmlRead_MaxDistance_3 = "RollOffMaxDistance" },
		ViewportFrame = { CameraCFrame = function(i) return i.CurrentCamera and i.CurrentCamera.CFrame or CFrame.identity end, CameraFieldOfView = function(i) return math.rad(i.CurrentCamera and i.CurrentCamera.FieldOfView or 70) end },
		WeldConstraint = { CFrame0 = function(i) return (i.Part0 and i.Part1) and i.Part0.CFrame:ToObjectSpace(i.Part1.CFrame) or CFrame.identity end, Part0Internal = "Part0", Part1Internal = "Part1", State = function(i) return __COUNT_BITS(i.Enabled, i.Active) end },
		Workspace = {
			CollisionGroupData = function()
				local cg = game:GetService("PhysicsService"):GetRegisteredCollisionGroups()
				if #cg == 0 then return "\1\0" end
				local b_size = 2
				for _, g in cg do b_size += 7 + #g.name end
				local b = buffer.create(b_size)
				buffer.writeu8(b, 0, 1); buffer.writeu8(b, 1, #cg)
				local offset = 2
				for i, g in cg do
					local n_len = #g.name
					buffer.writeu8(b, offset, i - 1); offset += 1
					buffer.writeu8(b, offset, attr_Type_IDs["int32"]); offset += 1
					buffer.writei32(b, offset, g.mask); offset += 4
					buffer.writeu8(b, offset, n_len); offset += 1
					buffer.writestring(b, offset, g.name); offset += n_len
				end
				return buffer.tostring(b)
			end,
		},
	}
	for _, ei in Enum.Material:GetEnumItems() do NotScriptableFixes.MaterialService[ei.Name .. "Name"] = function(i) return i:GetBaseMaterialOverride(ei) end end

	FetchAPI = function()
		local API_Dump
		local MaxCap = SecurityCapabilities.new(unpack(Enum.SecurityCapability:GetEnumItems()))
		local filter = { Security = MaxCap, ExcludeDisplay = true, ExcludeInherited = true }

		local fetchers = {
			function() local r = readfile(FULL_VERSION); return (r and r ~= "" and service.HttpService:JSONDecode(r)) and r or nil end,
			function() return service.HttpService:JSONEncode(service.HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/Mini-API-Dump.json", true)).Classes) end
		}
		
		for i, f in fetchers do
			local o, r = pcall(f)
			if o and r then API_Dump = r break end
		end

		local classList = {}
		local tmp_classDict = {}
		local Decoded = service.HttpService:JSONDecode(API_Dump)

		for _, AC in Decoded do
			local props = {}
			for _, M in AC.Members do
				if M.MemberType == "Property" or M.MemberType == "Function" then
					props[M.Name] = { ValueType = M.MemberType == "Property" and M.ValueType.Name, MemberType = M.MemberType }
				end
			end
			tmp_classDict[AC.Name] = props
		end

		for _, AC in Decoded do
			local cProps, cp_size = {}, 1
			local Class = { Properties = cProps, Superclass = AC.Superclass, NotCreatable = AC.Tags and ArrayToDict(AC.Tags, nil, nil, "string").NotCreatable }
			if AC.Tags then Class.Service = ArrayToDict(AC.Tags, nil, nil, "string").Service end
			
			local NSFClass = NotScriptableFixes[AC.Name]
			local CWhite, CBlack = ClassPropertyExceptions.Whitelist[AC.Name], ClassPropertyExceptions.Blacklist[AC.Name]

			for _, M in AC.Members do
				if M.MemberType == "Property" and M.Serialization.CanLoad then
					if (M.Serialization.CanSave or (CWhite and CWhite[M.Name])) and not (CBlack and CBlack[M.Name]) then
						local Prop = { Name = M.Name, Category = M.ValueType.Category, ValueType = M.ValueType.Name }
						
						if M.Tags then
							for _, t in M.Tags do
								if t == "NotScriptable" then Prop.Special = true break end
							end
						end
						
						if string.sub(Prop.ValueType, 1, 8) == "Optional" then Prop.Optional = string.sub(Prop.ValueType, 9) end
						
						local NSF = NSFClass and NSFClass[M.Name]
						Prop.Fallback = type(NSF) == "function" and NSF or (NSF and function(i) return i[NSF] end)
						
						cProps[cp_size] = Prop
						cp_size += 1
					end
				end
			end
			classList[AC.Name] = Class
		end
		return classList
	end
end

local GLOBAL_ENV = getgenv and getgenv() or _G or shared

local function synsaveinstance(CustomOptions, CustomOptions2)
	if GLOBAL_ENV.USSI then return end
	GLOBAL_ENV.USSI = true

	local currentstr, currentsize, totalsize, chunks = "", 0, 0, table.create(1)
	local savebuffer, savebuffer_size = {}, 1
	local header = '<roblox version="4">'
	local StatusText

	local OPTIONS = {
		mode = "optimized", noscripts = false, scriptcache = true, timeout = 10, __DEBUG_MODE = false, Callback = false,
		DecompileJobless = false, DecompileIgnore = { "TextChatService", ModuleScript = nil },
		IgnoreDefaultPlayerScripts = true, SaveBytecode = false, IgnoreProperties = {}, IgnoreList = { "CoreGui", "CorePackages" },
		ExtraInstances = {}, NilInstances = false, NilInstancesFixes = {}, SaveCacheInterval = 0x1600 * 10,
		ShowStatus = true, KillAllScripts = true, SafeMode = true, ShutdownWhenDone = false, AntiIdle = true, Anonymous = false,
		ReadMe = true, FilePath = false, AvoidFileOverwrite = true, Object = false, IsModel = false,
		IgnoreDefaultProperties = true, IgnoreNotArchivable = true, IgnorePropertiesOfNotScriptsOnScriptsMode = false,
		IgnoreSpecialProperties = ArrayToDict({ "Fluxus", "Delta", "Solara" })[EXECUTOR_NAME] or false,
		IsolateLocalPlayer = false, IsolateLocalPlayerCharacter = false, IsolatePlayers = false, IsolateStarterPlayer = false, RemovePlayerCharacters = true, SaveNotCreatable = false,
		NotCreatableFixes = { "", "AdvancedDragger", "AnimationTrack", "Dragger", "Player", "PlayerGui", "PlayerMouse", "PlayerScripts", "ScreenshotHud", "StudioData", "TextChatMessage", "TextSource", "TouchTransmitter", "Translator", CloudLocalizationTable = "LocalizationTable", Platform = "Part", Status = "Model" },
		IgnoreSharedStrings = EXECUTOR_NAME ~= "Wave", SharedStringOverwrite = false, TreatUnionsAsParts = EXECUTOR_NAME == "Solara",
		AlternativeWritefile = not ArrayToDict({ "WRD", "Xeno", "Zorara" })[EXECUTOR_NAME],
		OptionsAliases = { DecompileTimeout = "timeout", FileName = "FilePath", IgnoreArchivable = "IgnoreNotArchivable", IgnoreDefaultProps = "IgnoreDefaultProperties", InstancesBlacklist = "IgnoreList", IsolatePlayerGui = "IsolateLocalPlayer", SaveNonCreatable = "SaveNotCreatable", SavePlayers = "IsolatePlayers" },
	}

	-- Settings Initialization
	local OPTIONS_lowercase, CustomOptions_valid = {}, {}
	for k, v in OPTIONS do OPTIONS_lowercase[string.lower(k)] = k end
	for a, n in OPTIONS.OptionsAliases do OPTIONS_lowercase[string.lower(a)] = n end

	do
		local function construct_NilinstanceFix(Name, ClassName, Separate)
			return function(instance, instancePropertyOverrides)
				local Fix = (not Separate) and OPTIONS.NilInstancesFixes[Name]
				if not Fix then
					Fix = Instance.new(ClassName)
					if not Separate then OPTIONS.NilInstancesFixes[Name] = Fix end
					instancePropertyOverrides[Fix] = { __SaveSpecific = true, __Children = { instance }, Properties = { Name = Name } }
					return Fix
				end
				table.insert(instancePropertyOverrides[Fix].__Children, instance)
			end
		end

		OPTIONS.NilInstancesFixes.Animator = construct_NilinstanceFix("Animator has to be placed under Humanoid or AnimationController", "AnimationController")
		OPTIONS.NilInstancesFixes.AdPortal = construct_NilinstanceFix("AdPortal must be parented to a Part", "Part")
		OPTIONS.NilInstancesFixes.Attachment = construct_NilinstanceFix("Attachments must be parented to a BasePart or another Attachment", "Part")
		OPTIONS.NilInstancesFixes.BaseWrap = construct_NilinstanceFix("BaseWrap must be parented to a MeshPart", "MeshPart")
		OPTIONS.NilInstancesFixes.PackageLink = construct_NilinstanceFix("Package already has a PackageLink", "Folder", true)

		if CustomOptions2 and type(CustomOptions2) == "table" then
			local tmp = CustomOptions; CustomOptions = CustomOptions2
			if typeof(tmp) == "Instance" then CustomOptions.Object = tmp elseif typeof(tmp) == "table" and typeof(tmp[1]) == "Instance" then CustomOptions.ExtraInstances = tmp OPTIONS.IsModel = true end
		end

		if type(CustomOptions) == "table" then
			if typeof(CustomOptions[1]) == "Instance" then
				OPTIONS.mode = "invalidmode"; OPTIONS.ExtraInstances = CustomOptions; OPTIONS.IsModel = true
			else
				for k, v in CustomOptions do
					local opt = OPTIONS_lowercase[string.lower(k)]
					if opt then OPTIONS[opt] = v; CustomOptions_valid[opt] = true end
				end
			end
		elseif typeof(CustomOptions) == "Instance" then
			OPTIONS.mode = "invalidmode"; OPTIONS.Object = CustomOptions
		end
	end

	if not writefile and not OPTIONS.Callback then
		warn("Function 'writefile' is NOT available. Use the Option 'Callback' instead.")
		GLOBAL_ENV.USSI = nil return
	end

	local InstancesOverrides = {}
	local DecompileIgnore, IgnoreList, IgnoreProperties, NotCreatableFixes = ArrayToDict(OPTIONS.DecompileIgnore, true), ArrayToDict(OPTIONS.IgnoreList, true), ArrayToDict(OPTIONS.IgnoreProperties), ArrayToDict(OPTIONS.NotCreatableFixes, true, "Folder")
	
	local SafeMode = OPTIONS.SafeMode
	local FilePath = OPTIONS.FilePath
	local SaveCacheInterval = OPTIONS.SaveCacheInterval
	local ToSaveInstance = OPTIONS.Object
	local IsModel = OPTIONS.IsModel

	if ToSaveInstance and CustomOptions.IsModel == nil then IsModel = true end
	
	local old_gethiddenproperty
	if OPTIONS and gethiddenproperty then old_gethiddenproperty = gethiddenproperty; gethiddenproperty = nil end

	local ScriptCache = OPTIONS.scriptcache and getscriptbytecode
	local ldeccache = GLOBAL_ENV.scriptcache
	if ScriptCache and not ldeccache then ldeccache = {}; GLOBAL_ENV.scriptcache = ldeccache end

	local ToSaveList, placename, elapse_t, SaveNotCreatableWillBeEnabled
	if ToSaveInstance == game then OPTIONS.mode = "full"; ToSaveInstance = nil; IsModel = nil end

	do
		local PlaceName = game.PlaceId
		pcall(function() PlaceName ..= " " .. service.MarketplaceService:GetProductInfoAsync(PlaceName).Name end)
		local function sanitizeFileName(str) return string.sub(string.gsub(string.gsub(string.gsub(str, "[^%w _]", ""), " +", " "), " +$", ""), 1, 240) end

		local filetype = IsModel and ".rbxmx" or ".rbxlx"
		placename = FilePath or (IsModel and sanitizeFileName("model " .. PlaceName .. " " .. (ToSaveInstance or OPTIONS.ExtraInstances[1] or game):GetFullName()) or sanitizeFileName("place " .. PlaceName))
		placename ..= filetype
		if GLOBAL_ENV[placename] then return end
		GLOBAL_ENV[placename] = true; GLOBAL_ENV.USSI = nil

		local TempRoot = ToSaveInstance or game
		local tmp = table.clone(OPTIONS.ExtraInstances)
		if OPTIONS.mode == "optimized" then
			for _, sName in {"Workspace", "Players", "Lighting", "MaterialService", "ReplicatedFirst", "ReplicatedStorage", "ServerScriptService", "ServerStorage", "StarterGui", "StarterPack", "StarterPlayer", "Teams", "SoundService", "Chat", "TextChatService", "LocalizationService", "JointsService"} do
				local _s = game:FindService(sName)
				if _s then table.insert(tmp, _s) end
			end
		end
		ToSaveList = tmp
		if ToSaveInstance then table.insert(ToSaveList, 1, ToSaveInstance) end
	end

	local function get_size_format()
		for i, unit in {"B", "KB", "MB", "GB", "TB"} do
			if totalsize < 0x400 ^ i then return math.floor(totalsize / (0x400 ^ (i - 1)) * 10) / 10 .. " " .. unit end
		end
	end

	local RunService = service.RunService
	local function wait_for_render() RunService.RenderStepped:Wait() end

	local ldecompile = function() return "-- Decompiling disabled/unavailable" end
	if decompile and not OPTIONS.noscripts then
		ldecompile = function(scr)
			if ScriptCache then
				local s, bc = getscriptbytecode(scr)
				if s and bc ~= "" and ldeccache[bc] then return ldeccache[bc] end
			end
			local s, r = pcall(decompile, scr)
			return s and string.gsub(r, "\0", "\\0") or "--[[ Failed to decompile ]]"
		end
	end

	local function GetLocalPlayer() return service.Players.LocalPlayer or service.Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or service.Players.LocalPlayer end

	local gethiddenproperty_fallback
	local function ReadProperty(instance, property, propertyName, special, category, optional)
		if property.CanRead == false then return "__BREAK" end
		local s, r
		if special and gethiddenproperty then
			s, r = pcall(gethiddenproperty, instance, propertyName)
			if s and r ~= nil then return r end
		else
			s, r = pcall(index, instance, propertyName)
			if s and r ~= nil then return r end
		end
		return "__BREAK"
	end

	local function ReturnItem(className, instance) return '<Item class="' .. className .. '" referent="' .. GetRef(instance) .. '"><Properties>' end
	local function ReturnProperty(tag, propertyName, value) return "<" .. tag .. ' name="' .. propertyName .. '">' .. value .. "</" .. tag .. ">" end

	local function save_cache(final)
		local savestr = table.concat(savebuffer)
		currentstr ..= savestr
		local len = #savestr
		totalsize += len; currentsize += len
		table.clear(savebuffer); savebuffer_size = 1

		if 200 * 1024 * 1024 < currentsize or final then
			table.insert(chunks, { size = currentsize, str = currentstr })
			currentstr = ""; currentsize = 0
		end
		if StatusText then StatusText.Text = "Saving.. Size: " .. get_size_format() end
		wait_for_render()
	end

	local function save_hierarchy(hierarchy)
		for _, instance in hierarchy do
			local IOverride = InstancesOverrides[instance]
			local ClassName = instance.ClassName
			if IgnoreList[instance] or (not instance.Archivable and OPTIONS.IgnoreNotArchivable) then continue end

			if IOverride and IOverride.__SaveSpecific then
				savebuffer[savebuffer_size] = ReturnItem(IOverride.__ClassName or ClassName, instance) .. "</Properties>"
				savebuffer_size += 1
			else
				savebuffer[savebuffer_size] = ReturnItem(ClassName, instance)
				savebuffer_size += 1
				
				for _, Prop in GetInheritedProps(ClassName) do
					if IgnoreProperties[Prop.Name] then continue end
					local raw = ReadProperty(instance, Prop, Prop.Name, Prop.Special, Prop.Category, Prop.Optional)
					if raw ~= "__BREAK" then
						local val, tag
						if Prop.Category == "Enum" then val, tag = XML_Descriptors.EnumItem(raw)
						elseif Prop.Category == "Class" then val = raw and GetRef(raw) or "null"; tag = "Ref"
						else
							local desc = XML_Descriptors[Prop.ValueType]
							if desc then val, tag = desc(raw); tag = tag or Prop.ValueType end
						end
						if tag then
							savebuffer[savebuffer_size] = ReturnProperty(tag, Prop.Name, val)
							savebuffer_size += 1
						end
					end
				end
				savebuffer[savebuffer_size] = "</Properties>"
				savebuffer_size += 1
			end
			local Children = IOverride and IOverride.__Children or instance:GetChildren()
			if #Children > 0 then save_hierarchy(Children) end
			savebuffer[savebuffer_size] = "</Item>"
			savebuffer_size += 1
			if SaveCacheInterval < savebuffer_size then save_cache() end
		end
	end

	local function save_game()
		if IsModel then header ..= '<Meta name="ExplicitAutoJoints">true</Meta>' end
		save_hierarchy(ToSaveList)
		
		savebuffer[savebuffer_size] = "<SharedStrings>"
		savebuffer_size += 1
		for value, identifier in SharedStrings do
			savebuffer[savebuffer_size] = '<SharedString md5="' .. identifier .. '">' .. value .. "</SharedString>"
			savebuffer_size += 1
		end
		savebuffer[savebuffer_size] = "</SharedStrings></roblox>"
		savebuffer_size += 1
		save_cache(true)

		local totalstr = header
		for _, chunk in chunks do totalstr ..= chunk.str end
		
		if OPTIONS.Callback then
			OPTIONS.Callback(totalstr, chunks, totalsize)
		else
			writefile(placename, totalstr)
		end
	end

	-- Run and Cleanup
	local ok, err = xpcall(function() 
		ClassList = FetchAPI()
		elapse_t = os.clock()
		save_game()
	end, debug.traceback)

	if old_gethiddenproperty then gethiddenproperty = old_gethiddenproperty end
	GLOBAL_ENV[placename] = nil

	if not ok then warn("Save failed: " .. tostring(err)) end
end

return synsaveinstance
