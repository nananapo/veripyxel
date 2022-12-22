BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

NAME=lifegame
MODULENAME=lifegame
SRC=${NAME}.v

all: ${NAME}.fs

# Synthesis
$(NAME).json: $(SRC)
	yosys -p "read_verilog $(SRC); synth_gowin -top $(MODULENAME) -json $(NAME).json"

# Place and Route
$(NAME)_pnr.json: $(NAME).json
	nextpnr-gowin --json $(NAME).json --freq 27 --write $(NAME)_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
$(NAME).fs: $(NAME)_pnr.json
	gowin_pack -d ${FAMILY} -o $(NAME).fs $(NAME)_pnr.json

# Program Board
load: $(NAME).fs
	openFPGALoader -b ${BOARD} $(NAME).fs -f

$(NAME)_test.o: $(SRC)
	iverilog -o $(NAME)_test.o -s test $(SRC)

test: $(NAME)_test.o
	vvp $(NAME)_test.o

# Cleanup build artifacts
clean:
	rm $(NAME).vcd $(NAME).fs $(NAME)_test.o


test_sbt:
	sbt -v "testOnly kntscpu.RiscvTest"

.PHONY: load clean test
.INTERMEDIATE: $(NAME)_pnr.json $(NAME).json $(NAME)_test.o
