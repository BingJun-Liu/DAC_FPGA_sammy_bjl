# FPGA Verilog Modules

Verilog RTL for an FPGA design that drives a serial address/data output using a
divided clock. `refclk` is divided down to `clk_250k`, gated into a stable
strobe clock, and used to sequence a chip-select/load handshake that shifts
out successive `ADDR` bits.

## Modules

- **[FPGA_TOP.v](FPGA_TOP.v)** — top-level module; wires the other modules together.
- **[div_8.v](div_8.v)** — divides the input clock (`clk`) by 8 to produce `clk_2`.
- **[clk_ctrl.v](clk_ctrl.v)** — waits for the divided clock to stabilize, then gates
  it into `STB_CLK_250K` and asserts `START`.
- **[CS_LD_ctrl.v](CS_LD_ctrl.v)** — generates the `CS` (chip-select) and `LOAD`
  handshake signals and reports completion via `Done`.
- **[addr_out.v](addr_out.v)** — increments an address counter on each `LOAD` pulse
  and shifts it out one bit at a time on `ADDR`.

## Signal flow

```
refclk -> div_8 -> clk_ctrl -> CS_LD_ctrl -> addr_out -> ADDR
```

## Parameters (FPGA_TOP)

| Parameter    | Default | Description                                   |
|--------------|---------|------------------------------------------------|
| `BIT_CNT_MAX`| 16383   | Number of bits shifted out per load cycle.     |
| `MARGIN`     | 1       | Address increment step applied on each `LOAD`. |
| `INITIAL`    | 0       | Initial value of the address counter.          |
