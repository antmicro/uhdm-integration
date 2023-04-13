package my_pkg;
  parameter int MuBi4Width = 4;
  typedef enum logic [MuBi4Width-1:0] {
    MuBi4True = 4'h6, // enabled
    MuBi4False = 4'h9  // disabled
  } mubi4_t;

  typedef struct packed {
    mubi4_t en; 
    mubi4_t rd_en;
    mubi4_t prog_en;
    mubi4_t erase_en;
    mubi4_t scramble_en;
    mubi4_t ecc_en;
    mubi4_t he_en;
    logic [8:0] base;
    logic [9:0] size;
  } mp_region_cfg_t;
endpackage : my_pkg

module flash_mp_data_region_sel import my_pkg::*; #(
  parameter int Regions = 1
) (
  output mp_region_cfg_t sel_cfg_o
);
endmodule // flash_mp_data_region_sel

module flash_mp import my_pkg::*; ();
  mp_region_cfg_t hw_sel_cfg;
  parameter int HwDataRules = 1;

  typedef enum logic [1:0] {
    PhaseSeed,
    PhaseRma,
    PhaseNone,
    PhaseInvalid
  } flash_lcmgr_phase_e;

  typedef struct packed {
    flash_lcmgr_phase_e   phase;
    mp_region_cfg_t cfg;
  } data_region_attr_t;

  parameter data_region_attr_t Test[HwDataRules] = '{
    '{
       phase: PhaseRma,
       cfg:   '{
                 en:          MuBi4True,
                 rd_en:       MuBi4True,
                 prog_en:     MuBi4True,
                 erase_en:    MuBi4True,
                 scramble_en: MuBi4True,
                 ecc_en:      MuBi4True,
                 he_en:       MuBi4True, // HW assumes high endurance
                 base:        '0,
                 size:        NumBanks * PagesPerBank
                }
     }
  };
  flash_mp_data_region_sel #(
    .Regions(HwDataRules)
  ) u_hw_sel (
    .region_attrs_i(Test)
  );
endmodule // flash_erase_ctrl
