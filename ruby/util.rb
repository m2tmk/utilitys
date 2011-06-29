#共通部分のあるオブジェクト
#同士を変換した新たなオブジェクトを返す
def meet_convert(set1, set2)
	ne ||= []
	set1.each do |s1|
		set2.each do |s2|
			if s1.meet(s2) then
				s3 = nil
				if s1.type <= s2.type then
					s3 = s1.clone
				else
					s3 = s2.clone
				end

				if s1.rank != s2.rank
				then
					s3.rank = ''
				end
				ne << s3
			end
		end
	end
	return ne
end

class Parson
	attr_accessor :id, :type, :code,
		:name, :age, :rank
	
	def meet(other)
		code == other.code
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

result1 = meet_convert([p1,p2], [p3,p4])
result2 = meet_convert([p1,p2], [p4,p5])

require 'pp'

result1.each do |r|
	pp r
end

puts '------'

result2.each do |r|
	pp r
end

puts '------'

list = [
	[p1,p2],
	[p3,p4],
	[p1,p5]
]

result3 = meet_convert(list.shift, list.shift)
meet_convert(result3, list.shift).each do |r|
	pp r
end

puts '------'
puts '------'

def meet_join(first, rest)
	if rest.empty? then
		return first
	else
		meet_join(meet_convert(first, rest.shift), rest)
	end
end

list = [
	[p1,p2],
	[p3,p4,p5],
	[p3,p5],
	[p3]
]

rs = meet_join(list.shift, list)
rs.each do |r|
	pp r
end
