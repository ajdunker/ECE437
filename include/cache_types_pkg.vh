`ifndef CACHE_TYPES_PKG_VH
`define CACHE_TYPES_PKG_VH
package cache_types_pkg;

typedef enum {IDLE, ALLOCATE1, ALLOCATE2, WBACK1, WBACK2, FLUSH1, FLUSH2, HIT_CNT, END_FLUSH} state_type;

endpackage
`endif
