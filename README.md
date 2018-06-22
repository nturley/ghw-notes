# Tags
Looks like each tag is a null terminated short string. It looks like we don't do any compression for GHW format.

* Start ("GHDLwave")
* Strings ("STR" - "EOS")
* Types ("TYP")
* Known_Types ("WKT")
* Hierarchy ("HIE")
* End of header ("EOH")
* Snapshot ("SNP" - "ESN")
* Cycles ("CYC" - "ECY") ...
* Directory ("DIR")
  * Section Table (Name, Position), ...
  * End of directory "EOD"
* "TAI"
  
## Simple Example GHW file's tags
`
GHDLwave STR EOS TYP WKT HIE EOH SNP ESN CYC ECY DIR STR TYP WKT HIE EOH SNP ESN CYC DIR EOD TAI
`
# Sections

## Header
Strings, types, known types, and hierarchy.

### Strings
* "STR" tag
* 4 NUL bytes
* 4 bytes string table length?
* 4 bytes string length?

string table entries
* 1 NUL byte
* "EOS" tag

### Types
* "TYP" tag
* 4 NUL bytes
* 4 bytes type table length

Type table entries
* 1 NUL byte

### Type Table Entry

#### Array
* 1 byte subtype array
* 1 NUL byte
* 4 bytes type ID
* 1 Byte Direction
* 1/4/8 Bytes Left
* 1/4/8 Bytes Right

#### Enum/Boolean
 * 1 byte kind
 * 4 byte string ID
 * 4 byte number of values
 * Value names

#### SubType Array


 
 



## Snapshot
Dumps initial value of all signals

## Cycle
Shows Signal value changes

## Directory
This is a map of tags and their file offsets starting from STR and ending with DIR.
