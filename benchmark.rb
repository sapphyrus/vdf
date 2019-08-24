require "bundler/inline"
gemfile do
	source "https://rubygems.org"

	gem "vdf4r"
	gem "vdf"

	require "benchmark"
end

def benchmark_file(filename, times = 1)
	File.open(filename) do |file|
		Benchmark.bm do |benchmark|

			benchmark.report("vdf") do
				times.times do
					VDF.parse(file.read)
				end
			end

			benchmark.report("vdf4r") do
				times.times do
					file.rewind #required for vdf4r
					parser = VDF4R::Parser.new(file)
					parser.parse
				end
			end
		end
	end
end

["small.vdf", "items_game.txt"].each do |filename|
	puts filename

	benchmark_file(filename)

	puts
end
