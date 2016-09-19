################################################################
#
# Makefile for packet_filter P4 project
#
################################################################

export TARGET_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

include ../../init.mk

ifndef P4FACTORY
P4FACTORY := $(TARGET_ROOT)/../..
endif
MAKEFILES_DIR := ${P4FACTORY}/makefiles

# This target's P4 name
export P4_INPUT := p4src/packet_filter.p4
export P4_NAME := packet_filter

# Common defines targets for P4 programs
include ${MAKEFILES_DIR}/common.mk

# Put custom targets in packet_filter-local.mk
-include packet_filter-local.mk

all:bm

