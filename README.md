# gwh-notes

# Structure

## Header
Includes strings, types, known types, and hierarchy.

I'm guessing that snapshots and cycles will reference strings and types by offset into these tables.

## Snapshot
Dumps initial value of all signals

## Cycle
Shows Signal value changes

## Directory
This is a map of tags and their file offsets starting from STR and ending with DIR.

# Tags
* Start Header ("GHDLwave")
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
