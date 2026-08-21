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

## Top-level I/O (FPGA_TOP)

2 inputs, 6 outputs — all 1-bit signals.

| Pin            | Dir    | Function                                                        |
|----------------|--------|-------------------------------------------------------------------|
| `CLR`          | input  | Asynchronous reset; clears all counters and outputs.             |
| `refclk`       | input  | Reference clock fed into the `div_8` clock divider.               |
| `clk_250k`     | output | Divided clock (`refclk` / 8) produced by `div_8`.                 |
| `STB_CLK_250K` | output | Gated/stabilized version of `clk_250k`, used to clock the control logic. |
| `START`        | output | Asserted once the divided clock has stabilized after reset.       |
| `CS`           | output | Chip-select strobe for the load handshake.                        |
| `LOAD`         | output | Load pulse; each pulse advances the address counter and shifts out one `ADDR` bit. |
| `ADDR`         | output | Serial address/data output, shifted out one bit per `LOAD` pulse. |

## Parameters (FPGA_TOP)

| Parameter    | Default | Description                                   |
|--------------|---------|------------------------------------------------|
| `BIT_CNT_MAX`| 16383   | Number of bits shifted out per load cycle.     |
| `MARGIN`     | 1       | Address increment step applied on each `LOAD`. |
| `INITIAL`    | 0       | Initial value of the address counter.          |
