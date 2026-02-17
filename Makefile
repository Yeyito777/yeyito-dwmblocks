.POSIX:

BIN := dwmblocks
BUILD_DIR := build
SRC_DIR := src
INC_DIR := include

DEBUG := 0
VERBOSE := 0
LIBS := xcb-atom

PREFIX := /usr/local
CFLAGS := -Ofast -I. -I$(INC_DIR) -std=c99
CFLAGS += -DBINARY=\"$(BIN)\" -D_POSIX_C_SOURCE=200809L
CFLAGS += -Wall -Wpedantic -Wextra -Wswitch-enum
CFLAGS += $(shell pkg-config --cflags $(LIBS))
LDLIBS := $(shell pkg-config --libs $(LIBS))

SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(subst $(SRC_DIR)/,$(BUILD_DIR)/,$(SRCS:.c=.o))

INSTALL_DIR := $(DESTDIR)$(PREFIX)/bin
SCRIPTS_DIR := scripts
SCRIPTS_INSTALL_DIR := $(shell echo ~$${SUDO_USER:-$$USER})/.local/bin
SCRIPTS := $(wildcard $(SCRIPTS_DIR)/sb-*)

# Prettify output
PRINTF := @printf "%-8s %s\n"
ifeq ($(VERBOSE), 0)
	Q := @
endif

ifeq ($(DEBUG), 1)
	CFLAGS += -g
endif

all: $(BUILD_DIR)/$(BIN)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c config.h
	$Qmkdir -p $(@D)
	$(PRINTF) "CC" $@
	$Q$(COMPILE.c) -o $@ $<

$(BUILD_DIR)/$(BIN): $(OBJS)
	$(PRINTF) "LD" $@
	$Q$(LINK.o) $^ $(LDLIBS) -o $@

clean:
	$(PRINTF) "CLEAN" $(BUILD_DIR)
	$Q$(RM) $(BUILD_DIR)/*

install: install-bin install-scripts

install-bin: $(BUILD_DIR)/$(BIN)
	$(PRINTF) "INSTALL" $(INSTALL_DIR)/$(BIN)
	$Qinstall -D -m 755 $< $(INSTALL_DIR)/$(BIN)

install-scripts:
	$Qmkdir -p $(SCRIPTS_INSTALL_DIR)
	$Qfor s in $(SCRIPTS); do \
		printf "%-8s %s\n" "INSTALL" "$(SCRIPTS_INSTALL_DIR)/$$(basename $$s)"; \
		install -m 755 $$s $(SCRIPTS_INSTALL_DIR)/; \
	done

uninstall:
	$(PRINTF) "RM" $(INSTALL_DIR)/$(BIN)
	$Q$(RM) $(INSTALL_DIR)/$(BIN)
	$Qfor s in $(SCRIPTS); do \
		printf "%-8s %s\n" "RM" "$(SCRIPTS_INSTALL_DIR)/$$(basename $$s)"; \
		$(RM) $(SCRIPTS_INSTALL_DIR)/$$(basename $$s); \
	done

.PHONY: all clean install install-bin install-scripts uninstall
