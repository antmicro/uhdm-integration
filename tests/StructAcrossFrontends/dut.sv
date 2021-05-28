package pkg1;
    typedef logic [5:0] named_type_t;
    parameter named_type_t named_type_default = 7;
    typedef struct packed {
        logic [3:0] tetra;
    } inner;
    typedef struct packed {
        inner [7:0] first;
    } struct1;
endpackage

package pkg2;
    typedef struct packed {
        logic [6:0] second;
    } struct1;
endpackage
