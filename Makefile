LINKLIBS="-lpthread"

FNAME=filesync

MAINFILE=$(FNAME).c
OUTFILE=$(FNAME).out

CFLAGS_OWN=-Wall -Wextra -static -std=c99
CFLAGS_DBG=-g -O0
CFLAGS_OPT=-Os -s
CFLAGS_OPT_AGGRESSIVE=-O3 -s -flto -fwhole-program

-include config.mak

CFLAGS_RCB_OPT_AGGRESSIVE=$(DB_FLAGS) ${CFLAGS_OWN} ${CFLAGS_OPT_AGGRESSIVE} ${CFLAGS}
CFLAGS_RCB_OPT=$(DB_FLAGS) ${CFLAGS_OWN} ${CFLAGS_OPT} ${CFLAGS}
CFLAGS_RCB_DBG=$(DB_FLAGS) ${CFLAGS_OWN} ${CFLAGS_DBG} ${CFLAGS}

all: debug

clean:
	rm -f $(OUTFILE)
	rm -f *.o
	rm -f $(FNAME).rcb

optimized:
	CFLAGS="${CFLAGS_RCB_OPT} -s" rcb2 $(RCBFLAGS) ${MAINFILE} $(LINKLIBS)
	strip --remove-section .comment ${OUTFILE}

optimized-aggressive:
	CFLAGS="${CFLAGS_RCB_OPT_AGGRESSIVE} -s" rcb2 $(RCBFLAGS) ${MAINFILE} $(LINKLIBS)
	strip --remove-section .comment ${OUTFILE}

odebug:
	CFLAGS="${CFLAGS_RCB_OPT} -g" rcb2 $(RCBFLAGS) ${MAINFILE} $(LINKLIBS)
	debug-stripper.sh $(OUTFILE)

debug:
	CFLAGS="${CFLAGS_RCB_DBG}" rcb2 $(RCBFLAGS) ${MAINFILE} $(LINKLIBS)


.PHONY: all optimized optimized-aggressive debug odebug
