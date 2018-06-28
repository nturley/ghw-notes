from ghw import Ghw
import pprint

def sig_val_info(sigval, ttable):
    t_index = sigval.sig_type_index
    t_data = ttable[t_index - 1].type_data
    t_name = strs[t_data.name - 1]
    val = t_data.values[sigval.val]
    return t_name, strs[val-1]

g = Ghw.from_file('examples/adder_tb.ghw')
curr_str = ''
prev_len = 0
strs = []
for s in g.string_table.strings:
    curr_str = curr_str[:prev_len] + str(bytearray(s.bytes[:-1]))
    prev_len = s.bytes[-1]
    strs.append(curr_str)

signal_names = []

print 'STRINGS'
print strs
print 'TYPES'
ttable = g.types_table.type_table
for t in ttable:
    tdata = t.type_data
    print strs[tdata.name - 1], [strs[x-1] for x in tdata.values]
print 'HIERARCHY'
level = 0
for h in g.hierarchy.signal_block:
    for el in h.elements:
        if hasattr(el, 'name'):
            name = strs[el.name-1]
        else:
            name = ''
        if el.hier_id == Ghw.HierType.signal:
            signal_names.append(name)
        if el.hier_id == Ghw.HierType.eos:
            level-=1
        if el.hier_id not in [Ghw.HierType.eos, Ghw.HierType.eoh]:
            print '  '*level, str(el.hier_id)[9:], name
        if el.hier_id in [Ghw.HierType.instance, Ghw.HierType.package]:
            level+=1
print 'SNAPSHOT'
print '  Time:', g.snapshot.current_time
for i, sig_name in enumerate(signal_names):
    sigval = g.snapshot.values[i]
    info = sig_val_info(sigval, ttable)
    print '   ',info[0], sig_name, '=', info[1]
print 'CYCLE'
print '  Time:', g.cycles.time
for c in g.cycles.changes[:-1]:
    print ' ', c.dt_bytes  
    for ch in c.sig_change[:-1]:
        sig_name = signal_names[ch.sig_key - 1]
        info = sig_val_info(ch.sig_val, ttable)
        print '   ',info[0], ch.sig_key, '=', info[1]


