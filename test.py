from ghw import Ghw
import pprint
g = Ghw.from_file('examples/adder_tb.ghw')

def print_public(o):
	pprint.pprint({k:v for k,v in vars(o).items() if not k.startswith('_')})

print_public(g)
print_public(g.sections)

curr_str = ''
prev_len = 0
strs = []
for s in g.sections.string_table.strings:
	curr_str = curr_str[:prev_len] + str(bytearray(s.bytes[:-1]))
	prev_len = s.bytes[-1]
	strs.append(curr_str)

print(strs)
print_public(g.sections.types_table)
print_public( g.sections.types_table.type_table[0])
print_public( g.sections.types_table.type_table[0].type_data)
print_public(g.sections.hierarchy)
level = 0
for h in g.sections.hierarchy.hier_scope:
	if hasattr(h, 'name'):
		name = strs[h.name-1]
	else:
		name = ''
	if h.hier_id == Ghw.HierType.eos:
		level-=1
	print '\t'*level, h.hier_id, name
	if h.hier_id in [Ghw.HierType.instance, Ghw.HierType.package]:
		level+=1