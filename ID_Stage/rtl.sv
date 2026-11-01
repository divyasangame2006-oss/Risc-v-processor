module id_stage(
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] wb_data,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_out,
    output logic [6:0]  opcode_out_d,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3_out_d,
    output logic        fn7_5,
    output logic [2:0]  aluop,
    output logic [1:0]  memtoreg,
    output logic        branch,
    output logic        mem_write,
    output logic        mem_read,
    output logic        alu_src,
    output logic        mux_in
);

    logic [4:0] rs1_sel;
    logic [4:0] rs2_sel;
    logic [4:0] rd_sel;

    logic [6:0] opcode;
    logic [2:0] fn3;

    logic [11:0] imm;
    logic [19:0] imm_uj;

    logic reg_write;
    logic reg_write_gated;

    // Decoder
    decoder u_decoder (
        .instruction(instruction),
        .rs1(rs1_sel),
        .rs2(rs2_sel),
        .rd(rd_sel),
        .opcode(opcode),
        .imm11_5(imm11_5),
        .fn3(fn3),
        .imm(imm),
        .imm_uj(imm_uj),
        .fn7_5(fn7_5)
    );

    // Immediate Generator
    imm_generator u_imm_generator (
        .imm_input(imm),
        .fn3(fn3),
        .opcode(opcode),
        .imm_input_uj(imm_uj),
        .imm_output(imm_out)
    );

    // Register Write Enable Gating
    assign reg_write_gated = reg_write && !stall;

    // Register File
    register_file u_register_file (
        .rs1_sel(rs1_sel),
        .rs2_sel(rs2_sel),
        .reg_write(reg_write_gated),
        .clk(clk),
        .reset(reset),
        .wb_data(wb_data),
        .rd_sel(rd_sel),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Main Control
    main_control u_main_control (
        .opcode(opcode),
        .fn3(fn3),
        .memtoreg(memtoreg),
        .branch(branch),
        .mux_in(mux_in),
        .memread(mem_read),
        .memwrite(mem_write),
        .alusrc(alu_src),
        .reg_write(reg_write),
        .aluop(aluop)
    );

    // Pass decoder outputs
    assign opcode_out_d = opcode;
    assign fn3_out_d = fn3;

endmodule
