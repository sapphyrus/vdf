# frozen_string_literal: true

require_relative 'vdf/version'
require_relative 'vdf/parse'
require_relative 'vdf/generate'

# Main VDF module
# @author sapphyrus
module VDF
	# Error while parsing a VDF document
	class ParserError < StandardError
	end
end
