#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vprim_generic_ram_1p.h"

vluint64_t main_time = 0;

int main(int argc, char* argv[])
{
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;

  Vprim_generic_ram_1p* top = new Vprim_generic_ram_1p;
  top->trace(tfp, 99);
  tfp->open("dump.vcd");

  top->clk_i = 0;
  top->req_i = 0;

  while (!Verilated::gotFinish()) {
    if (main_time >= 5000) break;

    if (main_time && main_time % 5 == 0) top->clk_i = !top->clk_i;

    switch (main_time) {
      case 100: top->req_i = 1; break;
      case 200:
		top->write_i = 1;
		break;

      default: break;
    }

    top->eval();
    tfp->dump(main_time);
    ++main_time;
  }

  top->final();
  tfp->close();

  return 0;
}
