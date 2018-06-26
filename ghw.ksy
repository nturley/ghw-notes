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
  - id: sections
    type: ghw_sections
enums:
  hier_type:
    0 : eoh         
    1 : design      
    3 : block       
    4 : generate_if 
    5 : generate_for
    6 : instance    
    7 : package     
    13 : process      
    14 : generic      
    15 : eos          
    16: signal       
    17: port_in      
    18: port_out     
    19: port_inout   
    20: port_buffer  
    21: port_linkage 
  endian:
    0 : unknown
    1 : little
    2 : big
  wkt_type:
    0: unknown
    1: boolean
    2: bit
    3: std_ulogic
  rtik:
    0 : top
    1 : library
    2 : package
    3 : package_body
    4 : entity
    5 : architecture
    6 : process
    7 : block
    8 : if_generate
    9 : for_generate
    10: instance
    11: constant
    12: iterator
    13: variable
    14: signal
    15: file
    16: port
    17: generic
    18: alias
    19: guard
    20: component
    21: attribute
    22: type_b2
    23: type_e8
    24: type_e32
    25: type_i32
    26: type_i64
    27: type_p32
    28: type_p64
    29: type_f64
    30: type_access
    31: type_array
    32: type_record
    33: type_file
    34: subtype_scalar
    35: subtype_array
    36: subtype_array_ptr
    37: subtype_unconstrained_array
    38: subtype_record
    39: subtype_access
    40: type_protected
    41: element
    42: unit
    43: attribute_transaction
    44: attribute_quiet
    45: attribute_stable
    46: error
types:
  ghw_sections:
    meta:
      endian:
        switch-on: _root.endian
        cases:
          'endian::little': le
          'endian::big': be
    seq:
      - id: string_table
        type: ghw_string_table
      - id: types_table
        type: ghw_types
      - id: wkt_table
        type: ghw_wkt_table
      - id: hierarchy
        type: ghw_hier
      - id: snapshot
        type: ghw_snapshot
      - id: cycles
        type: ghw_cycle
    types:
      ghw_cycle_cont:
        seq:
          - id: dt
            type: u4
          - id: vals
            type: u1
            repeat: expr
            repeat-expr: 4
      ghw_cycle:
        seq:
          - id: magic
            contents: "CYC\0"
          - id: time
            type: u8
          - id: changes
            type: ghw_cycle_cont
            repeat: expr
            repeat-expr: 8
            
      ghw_snapshot:
        seq:
          - id: magic
            contents: "SNP\0\0\0\0\0"
          - id: current_time
            type: u8
          - id: values
            type: u1
            repeat: expr
            repeat-expr: _parent.hierarchy.num_signals
          - id: foot
            contents: "ESN\0"
      ghw_hier_scope:
        seq:
          - id: hier_id
            type: u1
            enum: hier_type
          - id: name
            type: u1
            if: hier_id != hier_type::eos and hier_id != hier_type::eoh
          - id: type
            type: u1
            if: |
              hier_id == hier_type::signal or
              hier_id == hier_type::port_in or
              hier_id == hier_type::port_out
          - id: signal
            type: u1
            if: |
              hier_id == hier_type::signal or
              hier_id == hier_type::port_in or
              hier_id == hier_type::port_out
      ghw_hier:
        seq:
          - id: magic
            contents: "HIE\0\0\0\0\0"
          - id: num_scopes
            type: u4
          - id: num_scope_signals
            type: u4
          - id: num_signals
            type: u4
          - id: hier_scope
            type: ghw_hier_scope
            repeat: until
            repeat-until: _.hier_id == hier_type::eoh
          - id: foot
            contents: "EOH\0"
      ghw_wkt_table_entry:
        seq:
          - id: wkt_type
            type: u1
            enum: wkt_type
          - id: type_id
            type: u1
            if: wkt_type != wkt_type::unknown
      ghw_wkt_table:
        seq:
          - id: magic
            contents: "WKT\0\0\0\0\0"
          - id: wkt
            type: ghw_wkt_table_entry
            repeat: until
            repeat-until: _.wkt_type == wkt_type::unknown
      ghw_string_table:
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
          - id: eos
            contents: "EOS\0"
      ghw_str:
        seq:
          - id: bytes
            type: u1
            repeat: until
            repeat-until: _ <= 31 or ( _ >= 128 and _ <= 159 )
      ghw_types:
        seq:
          - id: magic
            contents: "TYP\0\0\0\0\0"
          - id: table_length
            type: u4
          - id: type_table
            type: ghw_type
            repeat: expr
            repeat-expr: table_length
          - id: mbz
            contents: [0]
      ghw_type:
        seq:
          - id: type_id
            type: u1
            enum: rtik
          - id: type_data
            type:
              switch-on: type_id
              cases:
                'rtik::type_b2': ghw_type_enum
                'rtik::type_e8': ghw_type_enum
      ghw_type_enum:
        seq:
          - id: name
            type: u1
          - id: values_len
            type: u1
          - id: values
            type: u1
            repeat: expr
            repeat-expr: values_len
