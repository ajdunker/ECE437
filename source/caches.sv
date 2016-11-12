/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  caches_if cif
);

  // icache
  icache  ICACHE(CLK, nRST, dcif, cif);
  // dcache
  dcache  DCACHE (
  CLK, 
  nRST, 
  cif.ccsnoopaddr,
  cif.ccwait,
  cif.ccinv,
  cif.dwait,
  cif.dload,
  cif.ccatomicinvalidate,
  cif.cccofreetomove,

  cif.cctrans,
  cif.dREN,
  cif.dWEN,
  cif.daddr,
  cif.dstore,
  cif.ccwrite,
  cif.ccsnoopchecking,
  cif.ccsnoopvalue,
  cif.ccsnoopvalid, 
  cif.ccatomicinvalidating,
  cif.ccatomicaddr,
  dcif
  //cif
  );

  // dcache invalidate before halt handled by dcache when exists
  //assign dcif.flushed = dcif.halt;

  //singlecycle
  //assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  //assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  //assign dcif.imemload = cif.iload;
  //assign dcif.dmemload = cif.dload;


  //assign cif.iREN = dcif.imemREN;
  //assign cif.dREN = dcif.dmemREN;
  //assign cif.dWEN = dcif.dmemWEN;
  //assign cif.dstore = dcif.dmemstore;
  //assign cif.iaddr = dcif.imemaddr;
  //assign cif.daddr = dcif.dmemaddr;

endmodule
