module VDF
	class Parser
		class << self
			REGEX = Regexp.new(
				'^("((?:\\\\.|[^\\\\"])+)"|([a-z0-9\\-\\_]+))' +
				'([ \t]*(' +
				'"((?:\\\\.|[^\\\\"])*)(")?' +
				'|([a-z0-9\\-\\_]+)' +
				'))?',
				Regexp::MULTILINE
			)

			def parse(text)
				lines = text.lines
				object = {}
				stack = [object]
				expect = false
				skip_lines = 0

				lines.each_with_index do |line, i|
					if skip_lines > 0
						skip_lines -= 1
						next
					end

					line.strip!
					next if line == -'' || line[0] == -'/'

					if line.start_with?(-'{')
						expect = false
						next
					elsif expect
						raise ParserError, "Invalid syntax on line #{i+1} (1)"
					end

					if line.start_with?(-'}')
						stack.pop
						next
					end

					loop do
						m = REGEX.match(line)
						if m.nil?
							raise ParserError, "Invalid syntax on line #{i+1} (2)"
						end

						key = m[2] || m[3]
						val = m[6] || m[8]

						if val.nil?
							if stack[-1][key].nil?
								stack[-1][key] = {}
							end
							stack.push(stack[-1][key])
							expect = true
						else
							if m[7].nil? && m[8].nil?
								line << -"\n" << lines[i+skip_lines+1].chomp
								skip_lines += 1
								next
							end

							stack[stack.length - 1][key] = begin
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

				return object
			end
		end
	end

	def parse(text)
		Parser.parse(text)
	end
	module_function :parse
end
