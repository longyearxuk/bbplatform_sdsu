FC=gfortran
FFLAGS = -O2 -ffixed-line-length-none
HEADS = baseline.h
COMMON_OBJS = calcrsp.o fftsub.o ft_th.o sort.o spline.o splint.o
ROTD50_OBJS = ${COMMON_OBJS} rotd50.o
ROTD100_OBJS = ${COMMON_OBJS} rotd100.o

all: rd50 rd100 clear

rd50: ${ROTD50_OBJS}
	${FC} ${FFLAGS} -o RotD50Fast ${ROTD50_OBJS}

rd100: ${ROTD100_OBJS}
	${FC} ${FFLAGS} -o RotD100 ${ROTD100_OBJS}

clear:
	rm -f ${ROTD100_OBJS} ${ROTD50_OBJS}

${OBJS}: ${HEADS}

clean:
	rm -f ${ROTD50_OBJS} ${ROTD100_OBJS} RotD50Fast rotd100 *~
