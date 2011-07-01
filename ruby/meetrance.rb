require 'pp'

module Meetrance
	def meet?(elem1, elem2)
		elem1 == elem2
	end

	def exec(elem1, elem2)
		if meet?(elem1, elem2) then
			yield(elem1, elem2)
		end
	end

	def change(set1, set2)
		ne ||= []
		set1.each do |e1|
			set2.each do |e2|
				exec(e1, e2) do |e1, e2|
					ne << yield(e1, e2)
				end
			end
		end
		ne.uniq
	end

	def convert(first, rest, &block)
		if rest.empty? then
			return first
		else
			convert(change(first, rest.shift, &block), rest, &block)
		end
	end
end


class Parson
	attr_accessor :id, :type, :code,
		:name, :age, :rank
end

class ParsonManager
	include Meetrance

	def meet?(p1, p2)
		p1.code == p2.code
	end

	def conv(ps)
		convert(ps.shift, ps) do |p1, p2|
				p3 = nil
			if p1.id <= p2.id then
				p3 = p1.clone
			else
				p3 = p2.clone
			end

			if p1.rank != p2.rank then
				p3.rank = ''
			end
			p3
		end
	end
end

p1 = Parson.new
p1.id = 1
p1.type = 1
p1.code = '001'
p1.name = 'aaa'
p1.age = 19
p1.rank = 'A'

p2 = Parson.new
p2.id = 2
p2.type = 1
p2.code = '011'
p2.name = 'xxx'
p2.age = 20
p2.rank = 'A'

p3 = Parson.new
p3.id = 3
p3.type = 2
p3.code = '001'
p3.name = 'bbb'
p3.age = 21
p3.rank = 'B'

p4 = Parson.new
p4.id = 4
p4.type = 2
p4.code = '011'
p4.name = 'xxx'
p4.age = 22
p4.rank = 'A'

p5 = Parson.new
p5.id = 5
p5.type = 2
p5.code = '021'
p5.name = 'ppp'
p5.age = 23
p5.rank = 'C'

pm = ParsonManager.new

list = [
	[p1,p2],
	[p3,p4,p5],
	[p3,p5],
	[p3]
]

rs = pm.conv(list)
rs.each do |r|
	pp r
end
