deliveries = [1,2,10,9,1,1,0,9,0,10,10]

frames = deliveries.map { _1 == 10 ? [10, 0] : _1 }.flatten.each_slice(2).to_a

p frames