module VDF
	# The Parser class is responsible for parsing a VDF document into a Ruby Hash
	# @see VDF.parse
	class Parser
		class << self
			# Regex for splitting up a line in a VDF document into meaningful parts. Taken from {https://github.com/node-steam/vdf/blob/master/src/index.ts#L18-L24}
			REGEX = Regexp.new(
				'^("((?:\\\\.|[^\\\\"])+)"|([a-z0-9\\-\\_]+))' +
				'([ \t]*(' +
				'"((?:\\\\.|[^\\\\"])*)(")?' +
				'|([a-z0-9\\-\\_]+)' +
				'))?',
				Regexp::MULTILINE
			)
			private_constant :REGEX

			# Parses a VDF document into a Ruby Hash and returns it
			#
			# For large files, it's recommended to pass the File object to VDF.parse instead of reading the whole File contents into memory
			#
			# @param input [String, File, #to_str, #each_line] the input object
			# @return [Hash] the contents of the VDF document, parsed into a Ruby Hash
			# @raise [ParserError] if the VDF document is invalid
			# @example Parse the contents of a VDF String
			#   contents = VDF.parse(string)
			# @example Parse the contents of a VDF File
			#   File.open("filename.vdf", "r") do |file|
			#   	contents = VDF.parse(file)
			#   	puts contents.inspect
			#   end
			def parse(input)
				raise ArgumentError, "Input has to respond to :each_line or :to_str" unless input.respond_to?(:each_line) || input.respond_to?(:to_str)
				input = StringIO.new(input) unless input.respond_to? :pos

				result = {}
				stack = [result]
				expect = false
				i = 0

				enum = input.each_line
				enum.with_index do |line, _|
					i += 1
					line.encode!("UTF-8").strip!
					next if line.empty? || line[0] == -'/'

					if line.start_with?(-'{')
						expect = false
						next
					elsif expect
						raise ParserError, "Invalid syntax on line #{i+1} (Expected bracket)"
					end

					if line.start_with?(-'}')
						stack.pop
						next
					end

					loop do
						if (m = REGEX.match(line)).nil?
							raise ParserError, "Invalid syntax on line #{i+1} (Line didn't match regex)"
						end

						key = m[2] || m[3]
						val = m[6] || m[8]

						if val.nil?
							if stack[-1][key].nil?
								stack[-1][key] = {}
							end
							stack << stack[-1][key]
							expect = true
						else
							if m[7].nil? && m[8].nil?
								if (next_line = enum.next).nil?
									raise ParserError, "Invalid syntax on line #{i+1} (Unexpected EOF)"
								end

								i += 1
								line << -"\n" << next_line.to_s.encode("UTF-8").strip
								next
							end

							stack[-1][key] = begin
								begin
									Integer(val)
								rescue ArgumentError
									Float(val)
								end
							rescue ArgumentError
								case val.downcase
								when -"true"
									true
								when -"false"
									false
								when -"null"
									nil
								else
									val
								end
							end
						end

						break
					end
				end

				raise ParserError, "Open parentheses somewhere" unless stack.length == 1

				return result
			end
		end
	end

	# Parses a VDF document into a Ruby Hash and returns it
	#
	# For large files, it's recommended to pass the File object to VDF.parse instead of reading the whole File contents into memory
	#
	# @param input [String, File, #to_str, #each_line] the input object
	# @return [Hash] the contents of the VDF document, parsed into a Ruby Hash
	# @raise [ParserError] if the VDF document is invalid
	# @example Parse the contents of a VDF String
	#   contents = VDF.parse(string)
	# @example Parse the contents of a VDF File
	#   File.open("filename.vdf", "r") do |file|
	#   	contents = VDF.parse(file)
	#   	puts contents.inspect
	#   end
	def parse(input)
		Parser.parse(input)
	end
	module_function :parse
end
