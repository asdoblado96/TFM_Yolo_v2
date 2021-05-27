
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

PACKAGE Components IS

	FUNCTION bits (L : INTEGER) RETURN INTEGER; -- Given a positive integer number, it returns the number of bits needed to represent it in unsinged.
	FUNCTION nextPow2 (L : INTEGER) RETURN INTEGER; -- Given an integer number, it returns the smallest power of 2 that is larger than that integer. 
	FUNCTION bitSwap(L, B, B0, B1 : INTEGER) RETURN INTEGER; -- Given an integer L, it swaps the bits B0 and B1. B is the number of bits of L.

	FUNCTION min(L, R : INTEGER) RETURN INTEGER;
	FUNCTION max(L, R : INTEGER) RETURN INTEGER;

	FUNCTION min(L, R : REAL) RETURN REAL;
	FUNCTION max(L, R : REAL) RETURN REAL;

	FUNCTION isEqual(A, B : INTEGER) RETURN INTEGER;
	FUNCTION isOdd(A : INTEGER) RETURN INTEGER;
	FUNCTION isEven(A : INTEGER) RETURN INTEGER;

	TYPE databus IS ARRAY (INTEGER RANGE <>, INTEGER RANGE <>) OF STD_LOGIC;

END Components;

--------------
---- BODY ----
--------------

PACKAGE BODY Components IS

	FUNCTION bits (L : INTEGER) RETURN INTEGER IS
	BEGIN
		FOR i IN 0 TO 100 LOOP
			IF L < 2 ** i THEN
				RETURN i;
			END IF;
		END LOOP;

		RETURN -1;
	END;

	FUNCTION nextPow2 (L : INTEGER) RETURN INTEGER IS
	BEGIN
		IF L = 0 THEN
			RETURN 0;
		END IF;

		FOR i IN 0 TO 100 LOOP
			IF L < 2 ** i + 1 THEN
				RETURN 2 ** i;
			END IF;
		END LOOP;

		RETURN -1;
	END;
	FUNCTION bitSwap(L, B, B0, B1 : INTEGER) RETURN INTEGER IS
		VARIABLE Lbin : unsigned(B - 1 DOWNTO 0);
		VARIABLE C : STD_LOGIC;
	BEGIN
		Lbin := to_unsigned(L, B);
		C := Lbin(B0);
		Lbin(B0) := Lbin(B1);
		Lbin(B1) := C;
		RETURN to_integer(Lbin);
	END;
	FUNCTION min(L, R : INTEGER) RETURN INTEGER IS
	BEGIN
		IF L < R THEN
			RETURN L;
		ELSE
			RETURN R;
		END IF;
	END;

	FUNCTION max(L, R : INTEGER) RETURN INTEGER IS
	BEGIN
		IF L < R THEN
			RETURN R;
		ELSE
			RETURN L;
		END IF;
	END;
	FUNCTION min(L, R : REAL) RETURN REAL IS
	BEGIN
		IF L < R THEN
			RETURN L;
		ELSE
			RETURN R;
		END IF;
	END;

	FUNCTION max(L, R : REAL) RETURN REAL IS
	BEGIN
		IF L < R THEN
			RETURN R;
		ELSE
			RETURN L;
		END IF;
	END;
	FUNCTION isEqual(A, B : INTEGER) RETURN INTEGER IS
	BEGIN
		IF A = B THEN
			RETURN 1;
		ELSE
			RETURN 0;
		END IF;
	END;
	FUNCTION isOdd(A : INTEGER) RETURN INTEGER IS
		VARIABLE I : real;
	BEGIN

		I := real(A)/real(2);

		IF floor(I) = I THEN -- Vale asi porque A es un numero entero.
			RETURN 0; -- es par, no impar
		ELSE
			RETURN 1;
		END IF;
	END;

	FUNCTION isEven(A : INTEGER) RETURN INTEGER IS
	BEGIN
		RETURN 1 - isOdd(A);
	END;
END Components;