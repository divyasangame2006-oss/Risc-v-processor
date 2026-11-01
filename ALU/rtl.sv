module alu #(parameter int DATA_WIDTH = 32)(
    input  logic [4:0] alu_control,
    input  logic [DATA_WIDTH-1:0] rs1_data,
    input  logic [DATA_WIDTH-1:0] rs2_data,
    output logic [DATA_WIDTH-1:0] alu_out,
    output logic zero
);

    always_comb begin

        alu_out = '0;
        zero = 1'b0;

        case (alu_control)

            // ADD
            5'b00000:
                alu_out = rs1_data + rs2_data;

            // SUB
            5'b00001:
                alu_out = rs1_data - rs2_data;

            // XOR
            5'b00010:
                alu_out = rs1_data ^ rs2_data;

            // OR
            5'b00011:
                alu_out = rs1_data | rs2_data;

            // AND
            5'b00100:
                alu_out = rs1_data & rs2_data;

            // SLL
            5'b00101:
                alu_out = rs1_data << rs2_data[4:0];

            // SRL
            5'b00110:
                alu_out = rs1_data >> rs2_data[4:0];

            // SRA
            5'b00111:
                alu_out = $signed(rs1_data) >>> rs2_data[4:0];

            // SLT - Signed comparison
            5'b01000:
                alu_out = ($signed(rs1_data) < $signed(rs2_data)) ? 1 : 0;

            // SLTU - Unsigned comparison
            5'b01001:
                alu_out = (rs1_data < rs2_data) ? 1 : 0;

            // BEQ
            5'b01010: begin
                alu_out = '0;
                zero = (rs1_data == rs2_data);
            end

            // BNE
            5'b01011: begin
                alu_out = '0;
                zero = (rs1_data != rs2_data);
            end

            // BLT - Signed
            5'b01100: begin
                alu_out = '0;
                zero = ($signed(rs1_data) < $signed(rs2_data));
            end

            // BGE - Signed
            5'b01101: begin
                alu_out = '0;
                zero = ($signed(rs1_data) >= $signed(rs2_data));
            end

            // BLTU - Unsigned
            5'b01110: begin
                alu_out = '0;
                zero = (rs1_data < rs2_data);
            end

            // BGEU - Unsigned
            5'b01111: begin
                alu_out = '0;
                zero = (rs1_data >= rs2_data);
            end

            // Unused operations
            default: begin
                alu_out = '0;
                zero = 1'b0;
            end

        endcase
    end

endmodule
