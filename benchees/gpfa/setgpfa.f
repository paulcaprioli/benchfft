*        SUBROUTINE 'SETGPFA'
*        SETUP ROUTINE FOR SELF-SORTING IN-PLACE
*            GENERALIZED PRIME FACTOR (COMPLEX) FFT [GPFA]
*
*        CALL SETGPFA(TRIGS,N)
*
*        INPUT :
*        -----
*        N IS THE LENGTH OF THE TRANSFORMS. N MUST BE OF THE FORM:
*          -----------------------------------
*            N = (2**IP) * (3**IQ) * (5**IR)
*          -----------------------------------
*
*        OUTPUT:
*        ------
*        TRIGS IS A TABLE OF TWIDDLE FACTORS,
*          OF LENGTH 2*IPQR (REAL) WORDS, WHERE:
*          --------------------------------------
*            IPQR = (2**IP) + (3**IQ) + (5**IR)
*          --------------------------------------
*
*        WRITTEN BY CLIVE TEMPERTON 1990
*
*----------------------------------------------------------------------
*
      SUBROUTINE SETGPFA(TRIGS,N)
*
      DIMENSION TRIGS(*)
      DIMENSION NJ(3)
*
*     DECOMPOSE N INTO FACTORS 2,3,5
*     ------------------------------
      NN = N
      IFAC = 2
*
      DO 30 LL = 1 , 3
      KK = 0
   10 CONTINUE
      IF (MOD(NN,IFAC).NE.0) GO TO 20
      KK = KK + 1
      NN = NN / IFAC
      GO TO 10
   20 CONTINUE
      NJ(LL) = KK
      IFAC = IFAC + LL
   30 CONTINUE
*
      IF (NN.NE.1) THEN
         WRITE(6,40) N
   40    FORMAT(' *** WARNING!!!',I10,' IS NOT A LEGAL VALUE OF N ***')
         RETURN
      ENDIF
*
      IP = NJ(1)
      IQ = NJ(2)
      IR = NJ(3)
*
*     COMPUTE LIST OF ROTATED TWIDDLE FACTORS
*     ---------------------------------------
      NJ(1) = 2**IP
      NJ(2) = 3**IQ
      NJ(3) = 5**IR
*
      TWOPI = 4.0 * ASIN(1.0)
      I = 1
*
      DO 60 LL = 1 , 3
      NI = NJ(LL)
      IF (NI.EQ.1) GO TO 60
*
      DEL = TWOPI / FLOAT(NI)
      IROT = N / NI
      KINK = MOD(IROT,NI)
      KK = 0
*
      DO 50 K = 1 , NI
      ANGLE = FLOAT(KK) * DEL
      TRIGS(I) = COS(ANGLE)
      TRIGS(I+1) = SIN(ANGLE)
      I = I + 2
      KK = KK + KINK
      IF (KK.GT.NI) KK = KK - NI
   50 CONTINUE
   60 CONTINUE
*
      RETURN
      END