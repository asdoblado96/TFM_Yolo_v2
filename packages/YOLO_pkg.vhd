
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

PACKAGE YOLO_pkg IS

  FUNCTION bits (L : INTEGER) RETURN INTEGER; -- Given a positive integer number, it returns the number of bits needed to represent it in unsinged.

  FUNCTION nextPow2 (L : INTEGER) RETURN INTEGER; -- Given an integer number, it returns the smallest power of 2 that is larger than that integer. 

  FUNCTION rows(layer : IN INTEGER := 1) RETURN INTEGER;

  FUNCTION columns(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION filters(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION channels(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION kernels(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION grid(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION step(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION layerbits(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION weightbits(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION bitsAddress(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION weightsbitsAddress(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION bufferwidth(layer : INTEGER := 1) RETURN INTEGER;

  FUNCTION delaymem(layer : INTEGER := 1) RETURN INTEGER;

END YOLO_pkg;

PACKAGE BODY YOLO_pkg IS

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

  FUNCTION rows(layer : IN INTEGER := 1) RETURN INTEGER IS
    VARIABLE rows : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 1 =>
        rows := 416;
      WHEN 2 =>
        rows := 208;
      WHEN 3 =>
        rows := 104;
      WHEN 4 =>
        rows := 52;
      WHEN 5 =>
        rows := 26;
      WHEN OTHERS =>
        rows := 13; --13
    END CASE;
    RETURN rows;
  END rows;

  FUNCTION columns(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE columns : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 1 =>
        columns := 416;
      WHEN 2 =>
        columns := 208;
      WHEN 3 =>
        columns := 104;
      WHEN 4 =>
        columns := 52;
      WHEN 5 =>
        columns := 26;
      WHEN OTHERS =>
        columns := 13; --13
    END CASE;
    RETURN columns;
  END columns;

  FUNCTION filters(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE filters : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 0 =>
        filters := 3;
      WHEN 1 =>
        filters := 16;
      WHEN 2 =>
        filters := 32;
      WHEN 3 =>
        filters := 64;
      WHEN 4 =>
        filters := 128;
      WHEN 5 =>
        filters := 256;
      WHEN 6 =>
        filters := 512; --512
      WHEN 7 =>
        filters := 1024;
      WHEN 8 =>
        filters := 1024;
      WHEN 9 =>
        filters := 126;
      WHEN OTHERS =>
        filters := 126; --0
    END CASE;
    RETURN filters;
  END filters;

  FUNCTION channels(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE channels : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 1 =>
        channels := 3;
      WHEN 2 =>
        channels := 16;
      WHEN 3 =>
        channels := 32;
      WHEN 4 =>
        channels := 64;
      WHEN 5 =>
        channels := 128;
      WHEN 6 =>
        channels := 256; --256
      WHEN 7 =>
        channels := 512;
      WHEN 8 =>
        channels := 1024;
      WHEN 9 =>
        channels := 1024;
      WHEN OTHERS =>
        channels := 1024; --0
    END CASE;
    RETURN channels;
  END channels;

  FUNCTION kernels(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE kernels : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 0 =>
        kernels := 1;
      WHEN 1 =>
        kernels := 1;
      WHEN 2 =>
        kernels := 2;
      WHEN 3 =>
        kernels := 2;
      WHEN 4 =>
        kernels := 2;
      WHEN 5 =>
        kernels := 2;
      WHEN 6 =>
        kernels := 2;
      WHEN 7 =>
        kernels := 8;
      WHEN 8 =>
        kernels := 16;
      WHEN 9 =>
        kernels := 2;
      WHEN OTHERS =>
        kernels := 2; --1
    END CASE;
    RETURN kernels;
  END kernels;

  FUNCTION grid(layer : INTEGER := 1) RETURN INTEGER IS
  BEGIN
    RETURN 9;
  END grid;

  FUNCTION step (layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE step : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 6 =>
        step := 1;
      WHEN OTHERS =>
        step := 2;
    END CASE;
    RETURN step;
  END step;

  FUNCTION layerbits(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE layerbits : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 1 =>
        layerbits := 9;
      WHEN 9 =>
        layerbits := 16;
      WHEN OTHERS =>
        layerbits := 6;
    END CASE;
    RETURN layerbits;
  END layerbits;

  FUNCTION weightbits(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE weightbits : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 9 =>
        weightbits := 8;
      WHEN OTHERS =>
        weightbits := 1;
    END CASE;
    RETURN weightbits;
  END weightbits;

  FUNCTION bitsAddress(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE bitsAddress : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 0 =>
        bitsAddress := 17;
      WHEN 1 =>
        bitsAddress := 17;
      WHEN 2 =>
        bitsAddress := 15;
      WHEN 3 =>
        bitsAddress := 14;
      WHEN 4 =>
        bitsAddress := 13;
      WHEN 5 =>
        bitsAddress := 12;
      WHEN 6 =>
        bitsAddress := 13;
      WHEN 7 =>
        bitsAddress := 12;
      WHEN 8 =>
        bitsAddress := 11;
      WHEN 9 =>
        bitsAddress := 11;
      WHEN OTHERS =>
        bitsAddress := 11;
    END CASE;
    RETURN bitsAddress;
  END bitsAddress;

  FUNCTION weightsbitsAddress(layer : INTEGER := 1) RETURN INTEGER IS --DATOS INCOMPLETOS??
    VARIABLE weightsbitsAddress : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 1 =>
        weightsbitsAddress := 6;
      WHEN 2 =>
        weightsbitsAddress := 8;
      WHEN 3 =>
        weightsbitsAddress := 10;
      WHEN 4 =>
        weightsbitsAddress := 12;
      WHEN 5 =>
        weightsbitsAddress := 14;
      WHEN OTHERS =>
        weightsbitsAddress := 16;
    END CASE;
    RETURN weightsbitsAddress;
  END weightsbitsAddress;

  FUNCTION bufferwidth(layer : INTEGER := 1) RETURN INTEGER IS
    VARIABLE bufferwidth : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 1 =>
        bufferwidth := 14;
      WHEN 2 =>
        bufferwidth := 14;
      WHEN 3 =>
        bufferwidth := 15;
      WHEN 4 =>
        bufferwidth := 16;
      WHEN 5 =>
        bufferwidth := 17;
      WHEN 6 =>
        bufferwidth := 18;
      WHEN 7 =>
        bufferwidth := 19;
      WHEN 8 =>
        bufferwidth := 20;
      WHEN 9 =>
        bufferwidth := 16;
      WHEN OTHERS =>
        bufferwidth := 16;
    END CASE;
    RETURN bufferwidth;
  END bufferwidth;

  FUNCTION delaymem(layer : INTEGER := 1) RETURN INTEGER IS
  BEGIN
    RETURN 11927567;
  END delaymem;

END YOLO_pkg;