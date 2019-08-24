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

			def parse(input)
				raise ArgumentError, "Input has to respond to :each_line or :to_str" unless input.respond_to?(:each_line) || input.respond_to?(:to_str)
				input = StringIO.new(input) unless input.respond_to? :pos

				result = {}
				stack = [result]
				expect = false
				i = 0

				enum = input.each_line.lazy
				enum.with_index do |line, _|
					i += 1
					line.encode!("UTF-8").strip!
					next if line.empty? || line[0] == -'/'

					if line.start_with?(-'{')
						expect = false
						next
					elsif expect
						raise ParserError, "Invalid syntax on line #{i+1} (Expected identifier)"
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

				return result
			end
		end
	end

	def parse(text)
		Parser.parse(text)
	end
	module_function :parse
end
