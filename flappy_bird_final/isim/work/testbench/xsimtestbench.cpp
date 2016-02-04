#include "isim/work/testbench/testbench.h"
#include "isim/work/glbl/glbl.h"
static const char * HSimCopyRightNotice = "Copyright 2004-2005, Xilinx Inc. All rights reserved.";


#include "work/testbench/testbench.h"
static HSim__s6* IF0(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMtestbench(label); 
    return blk;
}


#include "work/ps2__kbd__driver/ps2__kbd__driver.h"
static HSim__s6* IF1(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMps2__kbd__driver(label); 
    return blk;
}


#include "work/pipe/pipe.h"
static HSim__s6* IF2(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMpipe(label); 
    return blk;
}


#include "work/_v_g_a/_v_g_a.h"
static HSim__s6* IF3(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workM_v_g_a(label); 
    return blk;
}


#include "work/vga__show/vga__show.h"
static HSim__s6* IF4(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMvga__show(label); 
    return blk;
}


#include "work/ps2__ctlr/ps2__ctlr.h"
static HSim__s6* IF5(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMps2__ctlr(label); 
    return blk;
}


#include "work/control/control.h"
static HSim__s6* IF6(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMcontrol(label); 
    return blk;
}


#include "work/clk__div/clk__div.h"
static HSim__s6* IF7(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMclk__div(label); 
    return blk;
}


#include "work/top/top.h"
static HSim__s6* IF8(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMtop(label); 
    return blk;
}


#include "work/glbl/glbl.h"
static HSim__s6* IF9(HSim__s6 *Arch,const char* label,int nGenerics, 
va_list vap)
{
    HSim__s6 *blk = new workMglbl(label); 
    return blk;
}

class _top : public HSim__s6 {
public:
    _top() : HSim__s6(false, "_top", "_top", 0, 0, HSim::VerilogModule) {}
    HSimConfigDecl * topModuleInstantiate() {
        HSimConfigDecl * cfgvh = 0;
        cfgvh = new HSimConfigDecl("default");
        (*cfgvh).addVlogModule("testbench", (HSimInstFactoryPtr)IF0);
        (*cfgvh).addVlogModule("ps2_kbd_driver", (HSimInstFactoryPtr)IF1);
        (*cfgvh).addVlogModule("pipe", (HSimInstFactoryPtr)IF2);
        (*cfgvh).addVlogModule("VGA", (HSimInstFactoryPtr)IF3);
        (*cfgvh).addVlogModule("vga_show", (HSimInstFactoryPtr)IF4);
        (*cfgvh).addVlogModule("ps2_ctlr", (HSimInstFactoryPtr)IF5);
        (*cfgvh).addVlogModule("control", (HSimInstFactoryPtr)IF6);
        (*cfgvh).addVlogModule("clk_div", (HSimInstFactoryPtr)IF7);
        (*cfgvh).addVlogModule("top", (HSimInstFactoryPtr)IF8);
        (*cfgvh).addVlogModule("glbl", (HSimInstFactoryPtr)IF9);
        HSim__s5 * topvl = 0;
        topvl = new workMtestbench("testbench");
        topvl->moduleInstantiate(cfgvh);
        addChild(topvl);
        topvl = new workMglbl("glbl");
        topvl->moduleInstantiate(cfgvh);
        addChild(topvl);
        return cfgvh;
}
};

main(int argc, char **argv) {
  HSimDesign::initDesign();
  globalKernel->getOptions(argc,argv);
  HSim__s6 * _top_i = 0;
  try {
    HSimConfigDecl *cfg;
 _top_i = new _top();
  cfg =  _top_i->topModuleInstantiate();
    return globalKernel->runTcl(cfg, _top_i, "_top", argc, argv);
  }
  catch (HSimError& msg){
    try {
      globalKernel->error(msg.ErrMsg);
      return 1;
    }
    catch(...) {}
      return 1;
  }
  catch (...){
    globalKernel->fatalError();
    return 1;
  }
}
