module M
  def self.const_missing(name)
    p :const_missing => name
    Module.new
  end

  p :in_M => N.name
end

module N

end

module M
  p :reopened_M => N.name
end

M.instance_exec{ p :instance_exec_M => N.name }
M.instance_exec{ p :instance_exec_colons_M => ::N.name }
M.module_exec{ p :module_exec_M => N.name }
M.module_exec{ p :module_exec_colons_M => ::N.name }
