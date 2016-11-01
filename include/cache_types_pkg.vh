`ifndef CACHE_TYPES_PKG_VH
`define CACHE_TYPES_PKG_VH
`include "cpu_types_pkg.vh"

package cache_types_pkg;

import cpu_types_pkg::*;
// i cache i cache  i cache  i cache  i cache  i cache  i cache  //
typedef struct packed
{
 logic [25:0] tag;
 logic [3:0] index;
 logic [1:0] offset;
} tempRow_t;

typedef struct packed
{
 logic v;
 logic [25:0] tag;
} icache_t;

typedef struct packed
{
 word_t value;
} value_t;

typedef enum bit
{
 Idle, Update
} istate_t;

// i cache  i cache  i cache  i cache  i cache  i cache  i cache //

   // ========================= DCACHE =========================

   typedef struct packed {
      logic [25:0] tag;
      logic [2:0]  index;
      logic 	   blockOffset;
      logic [1:0] aaa;
   } instruction_t;

   typedef struct  packed {
      logic 	   v; // Valid Bit
      logic 	   d; // Dirty Bit
      logic [25:0] tag;
   } dcache_frame_t;

   typedef struct  packed {
      word_t [1:0] values;
   } dcache_values_t;

   
typedef enum bit [3:0] {
  IDLE, WRITE_BACK1, WRITE_BACK2, UPDATE1, UPDATE2, WRITER, FLUSH_STATE1, FLUSH_STATE2, END_COUNT, END_OF_FLUSH
} dstate_t;
/////////////////////////  DCASH //////////////////////////////

endpackage
`endif
