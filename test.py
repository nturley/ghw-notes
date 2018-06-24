from ghw import Ghw

g = Ghw.from_file('examples/adder_tb.ghw')
print(vars(g))
curr_str = ''
prev_len = 0
for s in g.strings.strings:
	curr_str = curr_str[:prev_len] + str(bytearray(s.bytes[:-1]))
	prev_len = s.bytes[-1]
	print curr_str