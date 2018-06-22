# Sections

## Header
Strings, types, known types, and hierarchy.

I'm guessing that snapshots and cycles will reference strings and types by offset into these tables. The hierarchy shows where each signal is in the design.

## Snapshot
Dumps initial value of all signals

## Cycle
Shows Signal value changes

## Directory
This is a map of tags and their file offsets starting from STR and ending with DIR.

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
