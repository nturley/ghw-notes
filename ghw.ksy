meta:
  id: ghw
  title: GHDL Wave File
  file-extension:
    - ghw
  
seq:
  - id: magic
    contents: "GHDLwave\n"
  - id: hdr_info_len
    contents: [16]
  - id: major_version
    type: u1
  - id: minor_version
    type: u1
  - id: endian
    type: u1
    enum: endian
  - id: word_size
    type: u1
  - id: file_offset_size
    type: u1
  - id: must_be_zero
    contents: [0]
  - id: strings
    type: ghw_string_table
enums:
  endian:
    0 : unknown
    1 : little
    2 : big
types:
  ghw_string_table:
    meta:
      endian:
        switch-on: _root.endian
        cases:
          'endian::little': le
          'endian::big': be
    seq:
      - id: magic
        contents: "STR\0\0\0\0\0"
      - id: str_table_length
        type: u4
      - id: total_str_length
        type: u4
      - id: strings
        type: ghw_str
        repeat: expr
        repeat-expr: str_table_length
  ghw_str:
    seq:
      - id: bytes
        type: u1
        repeat: until
        repeat-until: _ <= 31 or ( _ >= 128 and _ <= 159 )  
    instances:
      str_val:
        value: bytes.as<str>.substring(0, bytes.size - 2)

      
# endian:
#     switch-on: endian
#     cases:
#       'endian::little': le
#       'endian::big': be
      
      