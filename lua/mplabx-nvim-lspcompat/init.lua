local function file_exists(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end

if file_exists("nbproject/configurations.xml")
	and file_exists("nbproject/private/configurations.xml")
	and not file_exists("compile_flags.txt") then

	local xml2lua = require("xml2lua")

	--Uses a handler that converts the XML to a Lua table
	local handler = require("xmlhandler.tree")

	local handler_pub = handler:new()
	local parser_pub = xml2lua.parser(handler_pub)
	parser_pub:parse(xml2lua.loadFile("nbproject/configurations.xml"))

	local toolsSet = handler_pub.root.configurationDescriptor.confs.conf.toolsSet

	local handler_priv = handler:new()
	local parser_priv = xml2lua.parser(handler_priv)
	parser_priv:parse(xml2lua.loadFile("nbproject/private/configurations.xml"))

	local toolchainDir = handler_priv.root.configurationDescriptor.confs.conf.languageToolchainDir

	local device = toolsSet.targetDevice

	if toolsSet.languageToolchain == "XC8" then

		local device_flag = "-D"..string.gsub(device,"PIC","_").."=1"
		local include_flag = "-I"..string.gsub(toolchainDir,"bin","pic/include")
		local file = io.open("compile_flags.txt", "w")
		file:write(include_flag.."\n")
		file:write(include_flag.."/legacy\n")
		file:write(include_flag.."/proc\n")
		file:write("-includebuiltins.h\n")
		file:write(device_flag)
		file:close()

	elseif toolsSet.languageToolchain == "XC16" then

		local device_flag = "-D__"..device.."__=1"
		local device_header = string.match(device,"[ds]*PIC%d%d%u")
		local include_flag = "-I"..string.gsub(toolchainDir,"bin","")
		local file = io.open("compile_flags.txt", "w")
		file:write(include_flag.."support/generic/h\n")
		file:write(include_flag.."support/"..device_header.."/h\n")
		file:write(include_flag.."etc/coverity/mchip/xc_16\n")
		file:write(device_flag)
		file:close()

	elseif toolsSet.languageToolchain == "XC32" then

	end



end
