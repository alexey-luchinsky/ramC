C-----------------
CAAFURAMBO.  A NEW MONTE CARLO TREATMENT OF MULTIPARTICLE PHASE SPACE AT AAFU000
C1   HIGH ENERGIES.  R. KLEISS, W.J. STIRLING, S.D. ELLIS.               AAFU000
CREF. IN COMP. PHYS. COMMUN. 40 (1986) 359                               AAFU000
      SUBROUTINE RAMBO(N,ET,XM,P,WT,LW)                                 AAFU0001
C------------------------------------------------------                 AAFU0002
C                                                                       AAFU0003
C                       RAMBO                                           AAFU0004
C                                                                       AAFU0005
C             RA(NDOM)  M(OMENTA)  BO(OSTER)                            AAFU0006
C                                                                       AAFU0007
C    A DEMOCRATIC MULTI-PARTICLE PHASE SPACE GENERATOR                  AAFU0008
C    AUTHORS:  S.D. ELLIS,  R. KLEISS,  W.J. STIRLING                   AAFU0009
C                                                                       AAFU0010
C    N  = NUMBER OF PARTICLES (>1, IN THIS VERSION <101)                AAFU0011
C    ET = TOTAL CENTRE-OF-MASS ENERGY                                   AAFU0012
C    XM = PARTICLE MASSES ( DIM=N )                                     AAFU0013
C    P  = PARTICLE MOMENTA ( DIM=(4,N) )                                AAFU0014
C    WT = WEIGHT OF THE EVENT                                           AAFU0015
C    LW = FLAG FOR EVENT WEIGHTING:                                     AAFU0016
C         LW = 0 WEIGHTED EVENTS                                        AAFU0017
C         LW = 1 UNWEIGHTED EVENTS ( FLAT PHASE SPACE )                 AAFU0018
C------------------------------------------------------                 AAFU0019
      IMPLICIT REAL*8(A-H,O-Z)                                          AAFU0020
      DIMENSION XM(N),P(4,N),Q(4,100),Z(100),R(4),                      AAFU0021
     .   B(3),P2(100),XM2(100),E(100),V(100),IWARN(5)                   AAFU0022
      external rndm2
      real*8 rndm2
      DATA ACC/1.D-14/,ITMAX/6/,IBEGIN/0/,IWARN/5*0/                    AAFU0023

C                                                                       AAFU0024
C INITIALIZATION STEP: FACTORIALS FOR THE PHASE SPACE WEIGHT            AAFU0025
      IF(IBEGIN.NE.0) GOTO 103                                          AAFU0026
      IBEGIN=1                                                          AAFU0027
      TWOPI=8.*DATAN(1.D0)                                              AAFU0028
      PO2LOG=DLOG(TWOPI/4.)                                             AAFU0029
      Z(2)=PO2LOG                                                       AAFU0030
      DO 101 K=3,100                                                    AAFU0031
  101 Z(K)=Z(K-1)+PO2LOG-2.*DLOG(DFLOAT(K-2))                           AAFU0032
      DO 102 K=3,100                                                    AAFU0033
  102 Z(K)=(Z(K)-DLOG(DFLOAT(K-1)))                                     AAFU0034
C                                                                       AAFU0035
C CHECK ON THE NUMBER OF PARTICLES                                      AAFU0036
  103 IF(N.GT.1.AND.N.LT.101) GOTO 104                                  AAFU0037
c      PRINT 1001,N                                                      AAFU0038
c avl      STOP                                                              AAFU0039

C                                                                       AAFU0040
C CHECK WHETHER TOTAL ENERGY IS SUFFICIENT; COUNT NONZERO MASSES        AAFU0041
  104 XMT=0.                                                            AAFU0042
      NM=0                                                              AAFU0043
      DO 105 I=1,N                                                      AAFU0044
      IF(XM(I).NE.0.D0) NM=NM+1                                         AAFU0045
  105 XMT=XMT+DABS(XM(I))                                               AAFU0046
      IF(XMT.LE.ET) GOTO 106                                            AAFU0047
c      PRINT 1002,XMT,ET                                                 AAFU0048
c avl      STOP                                                              AAFU0049
C                                                                       AAFU0050
C CHECK ON THE WEIGHTING OPTION                                         AAFU0051
  106 IF(LW.EQ.1.OR.LW.EQ.0) GOTO 201                                   AAFU0052
c      PRINT 1003,LW                                                     AAFU0053
c avl      STOP                                                              AAFU0054
C                                                                       AAFU0055
C THE PARAMETER VALUES ARE NOW ACCEPTED                                 AAFU0056
C                                                                       AAFU0057
C GENERATE N MASSLESS MOMENTA IN INFINITE PHASE SPACE                   AAFU0058
  201 DO 202 I=1,N                                                      AAFU0059
      C=2.*rndm2(dummy)-1.                                                     AAFU0060
      S=DSQRT(1.-C*C)                                                   AAFU0061
      F=TWOPI*rndm2(dummy)                                                     AAFU0062
      Q(4,I)=-DLOG(rndm2(dummy)*rndm2(dummy))                                         AAFU0063
      Q(3,I)=Q(4,I)*C                                                   AAFU0064
      Q(2,I)=Q(4,I)*S*DCOS(F)                                           AAFU0065
  202 Q(1,I)=Q(4,I)*S*DSIN(F)                                           AAFU0066
C                                                                       AAFU0067
C CALCULATE THE PARAMETERS OF THE CONFORMAL TRANSFORMATION              AAFU0068
      DO 203 I=1,4                                                      AAFU0069
  203 R(I)=0.                                                           AAFU0070
      DO 204 I=1,N                                                      AAFU0071
      DO 204 K=1,4                                                      AAFU0072
  204 R(K)=R(K)+Q(K,I)                                                  AAFU0073
      RMAS=DSQRT(R(4)**2-R(3)**2-R(2)**2-R(1)**2)                       AAFU0074
      DO 205 K=1,3                                                      AAFU0075
  205 B(K)=-R(K)/RMAS                                                   AAFU0076
      G=R(4)/RMAS                                                       AAFU0077
      A=1./(1.+G)                                                       AAFU0078
      X=ET/RMAS                                                         AAFU0079
C                                                                       AAFU0080
C TRANSFORM THE Q'S CONFORMALLY INTO THE P'S                            AAFU0081
      DO 207 I=1,N                                                      AAFU0082
      BQ=B(1)*Q(1,I)+B(2)*Q(2,I)+B(3)*Q(3,I)                            AAFU0083
      DO 206 K=1,3                                                      AAFU0084
  206 P(K,I)=X*(Q(K,I)+B(K)*(Q(4,I)+A*BQ))                              AAFU0085
  207 P(4,I)=X*(G*Q(4,I)+BQ)                                            AAFU0086
C                                                                       AAFU0087
C RETURN FOR UNWEIGHTED MASSLESS MOMENTA                                AAFU0088
      WT=1.D0                                                           AAFU0089
      IF(NM.EQ.0.AND.LW.EQ.1) RETURN                                    AAFU0090
C                                                                       AAFU0091
C CALCULATE WEIGHT AND POSSIBLE WARNINGS                                AAFU0092
      WT=PO2LOG                                                         AAFU0093
      IF(N.NE.2) WT=(2.*N-4.)*DLOG(ET)+Z(N)                             AAFU0094
      IF(WT.GE.-180.D0) GOTO 208                                        AAFU0095
c      IF(IWARN(1).LE.5) PRINT 1004,WT                                   AAFU0096
      IWARN(1)=IWARN(1)+1                                               AAFU0097
  208 IF(WT.LE. 174.D0) GOTO 209                                        AAFU0098
c      IF(IWARN(2).LE.5) PRINT 1005,WT                                   AAFU0099
      IWARN(2)=IWARN(2)+1                                               AAFU0100
C                                                                       AAFU0101
C RETURN FOR WEIGHTED MASSLESS MOMENTA                                  AAFU0102
  209 IF(NM.NE.0) GOTO 210                                              AAFU0103
      WT=DEXP(WT)                                                       AAFU0104
      RETURN                                                            AAFU0105
C                                                                       AAFU0106
C MASSIVE PARTICLES: RESCALE THE MOMENTA BY A FACTOR X                  AAFU0107
  210 XMAX=DSQRT(1.-(XMT/ET)**2)                                        AAFU0108
      DO 301 I=1,N                                                      AAFU0109
      XM2(I)=XM(I)**2                                                   AAFU0110
  301 P2(I)=P(4,I)**2                                                   AAFU0111
      ITER=0                                                            AAFU0112
      X=XMAX                                                            AAFU0113
      ACCU=ET*ACC                                                       AAFU0114
  302 F0=-ET                                                            AAFU0115
      G0=0.                                                             AAFU0116
      X2=X*X                                                            AAFU0117
      DO 303 I=1,N                                                      AAFU0118
      E(I)=DSQRT(XM2(I)+X2*P2(I))                                       AAFU0119
      F0=F0+E(I)                                                        AAFU0120
  303 G0=G0+P2(I)/E(I)                                                  AAFU0121
      IF(DABS(F0).LE.ACCU) GOTO 305                                     AAFU0122
      ITER=ITER+1                                                       AAFU0123
      IF(ITER.LE.ITMAX) GOTO 304                                        AAFU0124
c      PRINT 1006,ITMAX,ACC                                              AAFU0125
      GOTO 305                                                          AAFU0126
  304 X=X-F0/(X*G0)                                                     AAFU0127
      GOTO 302                                                          AAFU0128
  305 DO 307 I=1,N                                                      AAFU0129
      V(I)=X*P(4,I)                                                     AAFU0130
      DO 306 K=1,3                                                      AAFU0131
  306 P(K,I)=X*P(K,I)                                                   AAFU0132
  307 P(4,I)=E(I)                                                       AAFU0133
C                                                                       AAFU0134
C CALCULATE THE MASS-EFFECT WEIGHT FACTOR                               AAFU0135
      WT2=1.                                                            AAFU0136
      WT3=0.                                                            AAFU0137
      DO 308 I=1,N                                                      AAFU0138
      WT2=WT2*V(I)/E(I)                                                 AAFU0139
  308 WT3=WT3+V(I)**2/E(I)                                              AAFU0140
      WTM=(2.*N-3.)*DLOG(X)+DLOG(WT2/WT3*ET)                            AAFU0141
      IF(LW.EQ.1) GOTO 401                                              AAFU0142
C                                                                       AAFU0143
C RETURN FOR  WEIGHTED MASSIVE MOMENTA                                  AAFU0144
      WT=WT+WTM                                                         AAFU0145
      IF(WT.GE.-180.D0) GOTO 309                                        AAFU0146
c      IF(IWARN(3).LE.5) PRINT 1004,WT                                   AAFU0147
      IWARN(3)=IWARN(3)+1                                               AAFU0148
  309 IF(WT.LE. 174.D0) GOTO 310                                        AAFU0149
c      IF(IWARN(4).LE.5) PRINT 1005,WT                                   AAFU0150
      IWARN(4)=IWARN(4)+1                                               AAFU0151
  310 WT=DEXP(WT)                                                       AAFU0152
      RETURN                                                            AAFU0153
C                                                                       AAFU0154
C UNWEIGHTED MASSIVE MOMENTA REQUIRED: ESTIMATE MAXIMUM WEIGHT          AAFU0155
  401 WT=DEXP(WTM)                                                      AAFU0156
      IF(NM.GT.1) GOTO 402                                              AAFU0157
C                                                                       AAFU0158
C ONE MASSIVE PARTICLE                                                  AAFU0159
      WTMAX=XMAX**(4*N-6)                                               AAFU0160
      GOTO 405                                                          AAFU0161
  402 IF(NM.GT.2) GOTO 404                                              AAFU0162
C                                                                       AAFU0163
C TWO MASSIVE PARTICLES                                                 AAFU0164
      SM2=0.                                                            AAFU0165
      PM2=0.                                                            AAFU0166
      DO 403 I=1,N                                                      AAFU0167
      IF(XM(I).EQ.0.D0) GOTO 403                                        AAFU0168
      SM2=SM2+XM2(I)                                                    AAFU0169
      PM2=PM2*XM2(I)                                                    AAFU0170
  403 CONTINUE                                                          AAFU0171
      WTMAX=((1.-SM2/(ET**2))**2-4.*PM2/ET**4)**(N-1.5)                 AAFU0172
      GOTO 405                                                          AAFU0173
C                                                                       AAFU0174
C MORE THAN TWO MASSIVE PARTICLES: AN ESTIMATE ONLY                     AAFU0175
  404 WTMAX=XMAX**(2*N-5+NM)                                            AAFU0176
C                                                                       AAFU0177
C DETERMINE WHETHER OR NOT TO ACCEPT THIS EVENT                         AAFU0178
  405 W=WT/WTMAX                                                        AAFU0179
      IF(W.LE.1.D0) GOTO 406                                            AAFU0180
c      IF(IWARN(5).LE.5) PRINT 1007,WTMAX,W                              AAFU0181
      IWARN(5)=IWARN(5)+1                                               AAFU0182
  406 CONTINUE                                                          AAFU0183
      IF(W.LT.rndm2(dummy)) GOTO 201                                           AAFU0184
      WT=1.D0                                                           AAFU0185
      RETURN                                                            AAFU0186
 1001 FORMAT(' RAMBO FAILS: # OF PARTICLES =',I5,' IS NOT ALLOWED')     AAFU0187
 1002 FORMAT(' RAMBO FAILS: TOTAL MASS =',D15.6,' IS NOT',              AAFU0188
     . ' SMALLER THAN TOTAL ENERGY =',D15.6)                            AAFU0189
 1003 FORMAT(' RAMBO FAILS: LW=',I3,' IS NOT AN ALLOWED OPTION')        AAFU0190
 1004 FORMAT(' RAMBO WARNS: WEIGHT = EXP(',F20.9,') MAY UNDERFLOW')     AAFU0191
 1005 FORMAT(' RAMBO WARNS: WEIGHT = EXP(',F20.9,') MAY  OVERFLOW')     AAFU0192
 1006 FORMAT(' RAMBO WARNS:',I3,' ITERATIONS DID NOT GIVE THE',         AAFU0193
     . ' DESIRED ACCURACY =',D15.6)                                     AAFU0194
 1007 FORMAT(' RAMBO WARNS: ESTIMATE FOR MAXIMUM WEIGHT =',D15.6,       AAFU0195
     . '     EXCEEDED BY A FACTOR ',D15.6)                              AAFU0196
      END                                                               AAFU0197


c=========================================
c      function rndm2(dummy)
c-----------------------------------------
c      implicit none
c	real*8 rndm2
c      real*8 dummy
c      real r(5,5)
c      call RANDOM_NUMBER(r)
c      r=dble(r(1,1))
c      return
c      end
c      real*4 ran(100)
c      integer ilen

! 	rndm2=dble(rand())
c      ilen = 1
c      call ranecu(ran,ilen,1)
c      rndm2 = ran(1)
c		rndm2=dble(rand())
c      return
c      end


  	real*8 function Ram2(ecm, xm, p1, p2)
	real*8 ecm, xm(2), p1(4), p2(4)
	real*8  xp(4,2)
	real*8 wt
	call rambo(2,ecm,xm, xp,wt,0)
	do i=1,4
		p1(i)=xp(i,1)
		p2(i)=xp(i,2)
	end do
	Ram2=wt
	return
	end


  	real*8 function Ram3(ecm, xm, p1, p2, p3)
	real*8 ecm, xm(3), p1(4), p2(4), p3(4)
	real*8  xp(4,3)
	real*8 wt
	call rambo(3,ecm,xm, xp,wt,0)
	do i=1,4
		p1(i)=xp(i,1)
		p2(i)=xp(i,2)
		p3(i)=xp(i,3)
	end do
	Ram3=wt
	return
	end


 	real*8 function Ram4(ecm, xm, p1, p2, p3, p4)
	real*8 ecm, xm(4), p1(4), p2(4), p3(4), p4(4)
	real*8  xp(4,4)
	real*8 wt
	call rambo(4,ecm,xm, xp,wt,0)
	do i=1,4
		p1(i)=xp(i,1)
		p2(i)=xp(i,2)
		p3(i)=xp(i,3)
		p4(i)=xp(i,4)
	end do
	Ram4=wt
	return
	end

 	real*8 function Ram5(ecm, xm, p1, p2, p3, p4, p5)
	real*8 ecm, xm(5), p1(4), p2(4), p3(4), p4(4), p5(4)
	real*8  xp(4,5)
	real*8 wt
	call rambo(5,ecm,xm, xp,wt,0)
	do i=1,4
		p1(i)=xp(i,1)
		p2(i)=xp(i,2)
		p3(i)=xp(i,3)
		p4(i)=xp(i,4)
		p5(i)=xp(i,5)
	end do
	Ram5=wt
	return
	end

 	real*8 function Ram6(ecm, xm, p1, p2, p3, p4, p5, p6)
	real*8 ecm, xm(5), p1(4), p2(4), p3(4), p4(4), p5(4), p6(4)
	real*8  xp(4,6)
	real*8 wt
	call rambo(6,ecm,xm, xp,wt,0)
	do i=1,4
		p1(i)=xp(i,1)
		p2(i)=xp(i,2)
		p3(i)=xp(i,3)
		p4(i)=xp(i,4)
		p5(i)=xp(i,5)
		p6(i)=xp(i,6)
	end do
	Ram6=wt
	return
	end
        
 	real*8 function Ram7(ecm, xm, p1, p2, p3, p4, p5, p6, p7)
	real*8 ecm, xm(5), p1(4), p2(4), p3(4), p4(4), p5(4), p6(4), p7(4)
	real*8  xp(4,7)
	real*8 wt
	call rambo(7,ecm,xm, xp,wt,0)
	do i=1,4
		p1(i)=xp(i,1)
		p2(i)=xp(i,2)
		p3(i)=xp(i,3)
		p4(i)=xp(i,4)
		p5(i)=xp(i,5)
		p6(i)=xp(i,6)
		p7(i)=xp(i,7)
	end do
	Ram7=wt
	return
	end

 	real*8 function Ram8(ecm, xm, p1, p2, p3, p4, p5, p6, p7, p8)
	real*8 ecm, xm(5), p1(4), p2(4), p3(4), p4(4), p5(4), p6(4), p7(4)
        real*8 p8(4)
	real*8  xp(4,8)
	real*8 wt
	call rambo(8,ecm,xm, xp,wt,0)
	do i=1,4
		p1(i)=xp(i,1)
		p2(i)=xp(i,2)
		p3(i)=xp(i,3)
		p4(i)=xp(i,4)
		p5(i)=xp(i,5)
		p6(i)=xp(i,6)
		p7(i)=xp(i,7)
                p8(i)=xp(i,8)
	end do
	Ram8=wt
	return
	end

        
	subroutine init
	integer iseed1, iseed2
c 	call ranecq(iseed1,iseed2,1,' ')
	return
	end


