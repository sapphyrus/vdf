module VDF
	class Generator
		class << self
			def generate(object)
				object.inspect
			end
		end
	end

	def generate(object)
		Generator.generate(object)
	end
	module_function :generate
end
