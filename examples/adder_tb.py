
import struct

with open("adder_tb.ghw", "rb") as f:
    message = f.read(9)
    assert message=="GHDLwave\n"
    print 'Header Length:', struct.unpack("B",f.read(1))[0]
    print 'major version:', struct.unpack("B",f.read(1))[0]
    print 'minor version:', struct.unpack("B",f.read(1))[0]
    print 'Endianness:', struct.unpack("B",f.read(1))[0]
    print 'Word Size:', struct.unpack("B",f.read(1))[0]
    print 'File Offset Size:', struct.unpack("B",f.read(1))[0]
    print 'Must Be Zero:', struct.unpack("B",f.read(1))[0]
    print 'STR Tag:', f.read(4)
    f.read(4)
    print 'Number of Strings:', struct.unpack("i",f.read(4))[0]
    print 'String Table Size', struct.unpack("i",f.read(4))[0]
    prev = ''
    lens = [3,2,2,1,7,2,3,2,1,2,1,1,7]
    print 'Number of Strings:',len(lens)
    strs = []
    for nb in lens:
        message = prev + f.read(nb)
        strs.append(message)
        prev = message[:struct.unpack("B",f.read(1))[0]]
    print strs
    print 'String Table Size:', sum([len(x) for x in strs])
    print 'EOS Tag:', f.read(4)
    print 'TYP Tag:', f.read(4)
    message = f.read(9)
    print ":".join("{:02x}".format(ord(c)) for c in message)