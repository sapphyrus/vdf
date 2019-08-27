module VDF
	# The Generator class is responsible for generating VDF documents from input hashes.
	# @see VDF.generate
	class Generator
		class << self

			# Generates a VDF document from a Ruby Hash and returns it
			#
			# @param object [Hash] the input object
			# @return [String] the generated VDF document
			def generate(object)
				raise ArgumentError, "Object has to respond to each" unless object.respond_to? :each

				generate_impl(object, 0)
			end

			private

			def generate_impl(object, level)
				result = ""
				indent = -"\t"*level

				object.each do |key, value|
					if value.respond_to? :each
						result << [indent, -'"', key, -"\"\n", indent, -"{\n", generate_impl(value, level + 1), indent, -"}\n"].join
					else
						result << [indent, -'"', key, -'"', indent, indent, -'"', value.to_s, -"\"\n"].join
					end
				end

				result
			end
		end
	end

	# Generates a VDF document from a ruby hash.
	#
	# @param object [Hash] the input object
	# @return [String] the generated VDF document
	def generate(object)
		Generator.generate(object)
	end
	module_function :generate
end
