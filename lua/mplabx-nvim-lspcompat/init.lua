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

	local conf_aux = handler_pub.root.configurationDescriptor.confs.conf
	local toolsSet
	if conf_aux.toolsSet == nil then
		toolsSet = conf_aux[1].toolsSet
	else
		toolsSet = conf_aux.toolsSet
	end

	local handler_priv = handler:new()
	local parser_priv = xml2lua.parser(handler_priv)
	parser_priv:parse(xml2lua.loadFile("nbproject/private/configurations.xml"))

	conf_aux = handler_priv.root.configurationDescriptor.confs.conf
	local toolchainDir
	if conf_aux.languageToolchainDir == nil then
		toolchainDir = conf_aux[1].languageToolchainDir
	else
		toolchainDir = conf_aux.languageToolchainDir
	end

	local device = toolsSet.targetDevice

	if toolsSet.languageToolchain == "XC8" then

		local device_flag = "-D"..string.gsub(device,"PIC","_").."=1"
		local include_flag = "-I"..string.gsub(toolchainDir,"bin","pic/include")
		local file = io.open("compile_flags.txt", "w")
		file:write(include_flag.."\n")
		file:write(include_flag.."/legacy\n")
		file:write(include_flag.."/proc\n")
		file:write("-includebuiltins.h\n")
		file:write("-D__bit=char\n")
		file:write("-D__uint24=int\n")
		file:write("-Daddress(x)=weak\n")
		file:write(device_flag.."\n")
		if string.find(device, "PIC18") ~= -1 then
			file:write("-includepic18.h")
		else
			file:write("-includepic.h")
		end
		file:close()

	elseif toolsSet.languageToolchain == "XC16" then

		local device_flag = "-D__"..device.."__=1\n"
		local device_header = string.match(device,"[ds]*PIC%d%d%u")
		local include_flag = "-I"..string.gsub(toolchainDir,"bin","")
		local file = io.open("compile_flags.txt", "w")
		file:write(include_flag.."support/generic/h\n")
		file:write(include_flag.."support/"..device_header.."/h\n")
		file:write("-includebuiltins.h\n")
		file:write(device_flag)
		file:write("-U__clang__\n")
		file:write("-Dinline= \n")
		file:write("-D__inline= \n")
		file:write("-D__attribute__(x)= \n")
		file:write("-Dasm(x)= \n")
		file:write("-D__extension__= \n")
		file:write("-D__asm__(x)= \n")
		file:write("-D__pack_upper_byte= \n")
		file:write("-D__eds__= \n")
		file:write("-D__psv__= \n")
		file:write("-D__prog__= \n")
		file:write("-D__pmp__= \n")
		file:write("-D__external__= \n")
		file:write("-D__complex__= \n")
		file:write("-D__real__= \n")
		file:write("-D__imag__= \n")
		file:write("-D__at(x)= \n")
		file:write("-D__section(x)= \n")
		file:write("-D__bank(x)= \n")
		file:write("-D__align(x)= \n")
		file:write("-D__interrupt(x)= \n")
		file:write("-Dasm(x)= \n")
		file:write("-D__far= \n")
		file:write("-D__near= \n")
		file:write("-D__persistent= \n")
		file:write("-D__xdata= \n")
		file:write("-D__ydata= \n")
		file:write("-D__eeprom= \n")
		file:write("-D__pack= \n")
		file:write("-D__deprecate= \n")
		file:close()

	elseif toolsSet.languageToolchain == "XC32" then

	end



end
