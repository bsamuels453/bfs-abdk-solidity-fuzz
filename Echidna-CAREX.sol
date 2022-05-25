pragma solidity ^0.8.0;

import "ABDKMath64x64.sol";

contract Test {
  int128 internal zero = ABDKMath64x64.fromInt(0);
  int128 internal one = ABDKMath64x64.fromInt(1);
  uint128 internal fixed_max_u = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
  int128 internal fixed_max = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
  int128 internal fixed_min = -0x80000000000000000000000000000000;
  uint128 internal fixed_max_integer_u = 0x7FFFFFFFFFFFFFFF;
  int128 internal fixed_max_integer = 0x7FFFFFFFFFFFFFFF;
  int128 internal fixed_min_integer = -0x8000000000000000;
  int128 internal max_log_error = 100000000000000000; // chosen empirically. 

  event Value1(string, int64);
  event Value2(string, int128);
  event Value3(string, int256);
  event Value4(string, uint256);
  event Value5(string, uint64);


   function add(int128 x, int128 y) public returns (int128) {
     return ABDKMath64x64.add(x, y);
   }

  function sub(int128 x, int128 y) public returns (int128) {
     return ABDKMath64x64.sub(x, y);
   }

   function mul(int128 x, int128 y) public returns (int128) {
     return ABDKMath64x64.mul(x, y);
   }

   function fromInt(int256 x) public returns (int128) {
     return ABDKMath64x64.fromInt(x);
   }

  function toInt(int128 x) public returns (int64) {
    return ABDKMath64x64.toInt(x);
  }

   function fromUInt(uint256 x) public returns (int128) {
     return ABDKMath64x64.fromUInt(x);
   }

  function toUInt(int128 x) public returns (uint64) {
    return ABDKMath64x64.toUInt(x);
  }

  function pow(int128 x, uint256 y) public returns (int128) {
     return ABDKMath64x64.pow(x, y);
  }

  function neg(int128 x) public returns (int128) {
     return ABDKMath64x64.neg(x);
  }

  function abs(int128 x) public returns (int128) {
    return ABDKMath64x64.abs(x);
  }

  function avg(int128 x, int128 y) public returns (int128) {
    return ABDKMath64x64.avg(x,y);
  }

  function div(int128 x, int128 y) public returns (int128) {
    return ABDKMath64x64.div(x, y);
  }

  function from128x128(int256 x) public returns (int128) {
    return ABDKMath64x64.from128x128(x);
  }

  function to128x128(int128 x) public returns (int256) {
    return ABDKMath64x64.to128x128(x);
  }

  function muli(int128 x, int256 y) public returns (int256) {
    return ABDKMath64x64.muli(x,y);
  }

  function mulu(int128 x, uint256 y) public returns (uint256) {
    return ABDKMath64x64.mulu(x,y);
  }

  function sqrt(int128 x) public returns (int128) {
    return ABDKMath64x64.sqrt(x);
  }

  function ln(int128 x) public returns (int128) {
    return ABDKMath64x64.ln(x);
  }

  function exp(int128 x) public returns (int128) {
    return ABDKMath64x64.exp(x);
  }

  function gavg(int128 x, int128 y) public returns (int128) {
    return ABDKMath64x64.gavg(x,y);
  }

  function divi(int256 x, int256 y) public returns (int128) {
     return ABDKMath64x64.divi(x, y);
  }

  function divu(uint256 x, uint256 y) public returns (int128) {
     return ABDKMath64x64.divu(x, y);
  }

  function log_2(int128 x) public returns (int128) {
    return ABDKMath64x64.log_2(x);
  }

  function exp_2(int128 x) public returns (int128) {
    return ABDKMath64x64.exp_2(x);
  }

  function inv(int128 x) public returns (int128) {
    return ABDKMath64x64.inv(x);
  }
   


  /// @dev calculate the distance between two fixed point numbers.
  function _calculateErrorFixed(int128 x, int128 y)  internal returns (int128) {
    if(x > y){
      return abs(sub(x,y));
    } else {
      return abs(sub(y,x));
    }
  }

  /// @dev calculate the distance between two integers.
  function _calculateError(int256 x, int256 y)  internal returns (int256) {
    int256 d;
    if(x > y){
      d = x - y;
    } else {
      d =  y - x;
    }

    return (d < 0 ? -d : d);
  }

  /// @dev calculate the distance between two unsigned integers.
  function _calculateError(uint256 x, uint256 y)  internal returns (uint256) {
    if(x > y) {
      return x - y;
    } else{
      return y - x;
    }
  }

  /// @dev constrains fixed parameter x to the valid range defined by [min,max].
  function _clampFixedToValidRange(int128 x) internal returns (int128) {
    if(x == 0){
      return x;
    } else if(x > 0){
      int128 r = int128(x % (int256(fixed_max) + 1));
      return r;
    } else {
      int128 r = int128(x % (int256(fixed_min) - 1));
      return r;
    }
  }

  function _clampIntegerToValidRange(int256 x) internal returns (int256) {
    if(x == 0){
      return x;
    } else if(x > 0){
      return x % (int256(fixed_max_integer) + 1);
    } else {
      return x % (int256(fixed_min_integer) - 1);
    }
  }

  function _clampIntegerToValidRange(uint256 x) internal returns (uint256) {
    if(x == 0){
      return x;
    } else{
      return x % (uint256(uint128(fixed_max_integer)) + 1);
    }
  }

   function _toIntRoundToZero(int128 x) public returns (int64) {
     if (x >= 0)
       return ABDKMath64x64.toInt(x);
     else
       return -ABDKMath64x64.toInt(neg(x));
   }


  /* TESTS */ 

  /// @notice compare the output of inv with div. div(1,x) == inv(x) All reals.
  /// @param x fixed, clamped to valid range
  function compareDivWithInv(int128 x) public {
    x = _clampFixedToValidRange(x);
    require(x != 0);

    int128 divResult = div(one, x);
    emit Value2("divResult", divResult);

    // any input that didn't throw a revert in div, should not throw a revert in inv
    try this.inv(x) returns (int128 invResult) {
      emit Value2("invResult", invResult);
      assert(invResult == divResult);
    } catch ( bytes memory) {
      emit Value2("inv should not have reverted", 0);
      assert(false);
    }
  }

  /// @notice Test inverse function using an interval check. All reals.
  /*
  let x be a fixed real
  let x_upper = inv(inv(x) - epsilon)
  let x_lower = inv(inv(x) + epsilon)
  assert x_lower <= x <= x_upper
  This works with fixed numbers that are close to or equal to epsilon/fixed_min/fixed_max, so that's cool. 
  */
  function testInvUsingIntervals(int128 x) public {
    int128 inv_x = inv(x);
    emit Value2("inv_x", inv_x);
    int128 inv_inv_x = inv(inv_x);
    emit Value2("inv_inv_x", inv_inv_x);

    int128 x_lower = inv(inv_x+1);
    int128 x_upper = inv(inv_x-1);

    emit Value2("x_lower",x_lower);
    emit Value2("x_upper",x_upper);

    assert(x_lower <= x && x <= x_upper);
  }

  /// @notice tests binary log product identity log2(x*y) = log2(x) + log2(y)
  /// To avoid figuring out an algo to calculate error, only test |x| > 0.1
  /// Allowable error is 1 part in max_log_error 
  function testBinaryLogProductIdentity(int128 x, int128 y) public {
    require(x > 0 && y > 0);
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    // |x| > 0.1
    // |x| > 0.1
    require(x > div(one, fromInt(10)));
    require(y > div(one, fromInt(10)));
    emit Value2("x",x);
    emit Value2("y",y);

    int128 left = log_2(mul(x,y));
    int128 right = add(log_2(x), log_2(y));
    
    int128 error = _calculateErrorFixed(left, right);
    emit Value2("error",error);
    int128 tolerableError = div(x, fromInt(max_log_error));
    emit Value2("tolerableError",tolerableError);
    assert(error <= tolerableError);
  }


  /// @notice tests natural log product identity ln(x*y) = ln(x) + ln(y)
  /// To avoid figuring out an algo to calculate error, only test |x| > 0.1
  /// Allowable error is 1 part in max_log_error 
  function testNaturalLogProductIdentity(int128 x, int128 y) public {
    require(x > 0 && y > 0);
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    // |x| > 0.1
    // |x| > 0.1
    require(x > div(one, fromInt(10)));
    require(y > div(one, fromInt(10)));
    emit Value2("x",x);
    emit Value2("y",y);

    int128 left = ln(mul(x,y));
    int128 right = add(ln(x), ln(y));
    
    int128 error = _calculateErrorFixed(left, right);
    emit Value2("error",error);
    int128 tolerableError = div(x, fromInt(max_log_error));
    emit Value2("tolerableError",tolerableError);
    assert(error <= tolerableError);
  }


  /// @notice fuzzes e^(ln(x)) == x
  /// To avoid figuring out an algo to calculate error, only test |x| > 0.1
  /// Allowable error is 1 part in max_log_error 
  function testExponentialOfNaturalLog(int128 x) public {
    require(x > 0);
    x = _clampFixedToValidRange(x);
    // |x| > 0.1
    require(x > div(one, fromInt(10)));

    emit Value2("x",x);
    int128 natLogOfX = ln(x);
    require(natLogOfX != 0);
    emit Value2("natLogOfX",natLogOfX);

    int128 exponentialOfNatLog = exp(natLogOfX);
    require(exponentialOfNatLog != 0);
    emit Value2("exponentialOfNatLog",exponentialOfNatLog);

    int128 error  = _calculateErrorFixed(x, exponentialOfNatLog);
    emit Value2("error",error);
    int128 tolerableError = div(x, fromInt(max_log_error));
    emit Value2("tolerableError",tolerableError);
    assert(error <= tolerableError);
  }


  /// @notice fuzzes 2^(log2(x)) == x
  /// To avoid figuring out an algo to calculate error, only test |x| > 0.1
  /// Allowable error is 1 part in max_log_error 
  function testExponentialOfBinaryLog(int128 x) public {
    require(x > 0);
    x = _clampFixedToValidRange(x);
    // |x| > 0.1
    require(x > div(one, fromInt(10)));

    emit Value2("x",x);
    int128 natLogOfX = log_2(x);
    require(natLogOfX != 0);
    emit Value2("natLogOfX",natLogOfX);

    int128 exponentialOfNatLog = exp_2(natLogOfX);
    require(exponentialOfNatLog != 0);
    emit Value2("exponentialOfNatLog",exponentialOfNatLog);

    int128 error  = _calculateErrorFixed(x, exponentialOfNatLog);
    emit Value2("error",error);
    int128 tolerableError = div(x, fromInt(max_log_error));
    emit Value2("tolerableError",tolerableError);
    assert(error <= tolerableError);
  }

  /// @notice tests binary log by comparing to the quotient of natural logs log2(x) == ln(x)/ln(2)
  /// To avoid figuring out an algo to calculate error, only test |x| > 0.1
  /// Allowable error is 1 part in max_log_error 
  function testBinaryLogAsQuotientOfNaturalLog(int128 x) public {
    // |x| > 0.1
    require(x > div(one, fromInt(10)));

    int128 log2_x = log_2(x);
    emit Value2("log2(x)", log2_x);

    int128 ln_x = ln(x);
    emit Value2("ln(x)", ln_x);
    int128 ln_2 = ln(fromInt(2));
    emit Value2("ln(2)", ln_2);
    int128 log2_alt = div(ln_x, ln_2);
    emit Value2("log2_alt(2)", log2_alt);

    int128 error = _calculateErrorFixed(log2_x, log2_alt);
    emit Value2("error", error);
    int128 maxError = div(x, fromInt(max_log_error));
    emit Value2("maxerror", maxError);
    assert( error <= maxError);
  }



  /// @notice Tests toInt's decimal truncation behavior; ie: toInt(5.6) == 5, toInt(-2.5) == -3
  /// @param x integer to use 
  /// @param decimalComponent integer that will be used to construct a decimal. x_fixed = x + (1/decimalComponent)
  function testToIntTruncation(int256 x, uint128 decimalComponent) public {
    int128 x_fixed = fromInt(x);

    require(decimalComponent > 1);
    // |decimalComponentFixed| < 1
    int128 decimalComponentFixed = div(one, fromUInt(decimalComponent));
    emit Value2("decimalComponentFixed",decimalComponentFixed);

    // we want to make sure only x_fixed's decimals change, not the integer to the left of the decimal marker.
    int128 x_fixed_with_decimal;
    if(x_fixed >= 0){
      x_fixed_with_decimal = add(x_fixed, decimalComponentFixed);
    } else {
      x_fixed_with_decimal = sub(x_fixed, decimalComponentFixed);
      // https://discord.com/channels/814328279468474419/976477280404668507/978737966677639168
      x = x - 1;
    }
    emit Value2("x_fixed_with_decimal",x_fixed_with_decimal);

    int64 x_integer = toInt(x_fixed_with_decimal);
    emit Value2("x_integer",x_integer);
    assert(x_integer == x);
  }

  /// @notice Tests toUInt's decimal truncation behavior; ie: toUInt(5.6) == 5
  /// @param x integer to use 
  /// @param decimalComponent integer that will be used to construct a decimal. x_fixed = x + (1/decimalComponent)
  function testToUIntTruncation(uint256 x, uint128 decimalComponent) public {
    int128 x_fixed = fromUInt(x);

    require(decimalComponent > 1);
    // |decimalComponentFixed| < 1
    int128 decimalComponentFixed = div(one, fromUInt(decimalComponent));
    emit Value2("decimalComponentFixed",decimalComponentFixed);

    // we want to make sure only x_fixed's decimals change, not the integer to the left of the decimal marker.
    int128 x_fixed_with_decimal;
    x_fixed_with_decimal = add(x_fixed, decimalComponentFixed);
    emit Value2("x_fixed_with_decimal",x_fixed_with_decimal);

    uint64 x_integer = toUInt(x_fixed_with_decimal);
    emit Value4("x_integer",x_integer);
    assert(x_integer == x);
  }


  /// @notice compares the output of divu with div. All unsigned integers. Upper registers of divu won't be tested because of comparison with div.
  function compareDivuWithDiv(uint256 x, uint256 y) public {
    int128 q1 = div(fromUInt(x), fromUInt(y));
    emit Value2("q1", q1);

    // if we didn't get hit by a require() from div/fromUint, divu must not revert
    try this.divu(x,y) returns (int128 q2) {
      emit Value2("q2", q2);
      assert(q1 == q2);

    } catch (bytes memory) {
      emit Value2("divu reverted", 0);
      assert(false);
    }
  }

  /// @notice compares the output of divi with div. All signed integers. Upper registers of divi won't be tested because of comparison with div.
  function compareDiviWithDiv(int256 x, int256 y) public {
    int128 q1 = div(fromInt(x), fromInt(y));
    emit Value2("q1", q1);

    // if we didn't get hit by a require() from div/fromUint, divi must not revert
    try this.divi(x,y) returns (int128 q2) {
      emit Value2("q2", q2);
      assert(q1 == q2);

    } catch (bytes memory) {
      emit Value2("divi reverted", 0);
      assert(false);
    }
  }


  /// @notice compares the result of mul with the result of muli. Only operates on integers.
  /// @dev x operates over all reals, y over all integers
  /// @param x 64.64 signed fixed
  /// @param y integer
  function compareMulWithMuli(int128 x, int256 y) public {
    x = _clampFixedToValidRange(x);
    y = _clampIntegerToValidRange(y);
    int128 y_fixed = fromInt(y);
    emit Value2("y_fixed", y_fixed);

    // may revert, not a big deal
    int128 prod1 = mul(x,y_fixed);
    emit Value2("prod1", prod1);
    int256 prod1_integer = toInt(prod1);
    emit Value3("prod1_integer", prod1_integer);


    // must not revert
    try this.muli(x, y) returns (int256 prod2) { 
      emit Value3("prod2", prod2);

      int256 error = _calculateError(prod2, prod1_integer);
      emit Value3("error", error);
      // both functions round to zero, but under different conditions. allow 1 epsilon of error.
      assert(error <= 1);
      return;
    } catch (bytes memory ) { 
      assert(false);
      return;
    }
  }

  /// @notice compares the result of muli with solidity mul. Only operates on integers.
  /// @param x integer. will be converted to fixed. 
  /// @param y integer
  function compareMulWithMuli(int256 x, int256 y) public {
    x = _clampIntegerToValidRange(x);

    int128 x_fixed = fromInt(x);
    emit Value2("x_fixed", x_fixed);

    // may revert, not a big deal
    int256 prod1 = x * y;
    emit Value3("prod1", prod1);

    // must not revert
    try this.muli(x_fixed, y) returns (int256 prod2) { 
      emit Value3("prod2", prod2);
      int256 error = _calculateError(prod2, prod1);
      emit Value3("error", error);
      // both functions round to zero, but under different conditions. allow 1 epsilon of error.
      assert(error == 0);
      return;
    } catch (bytes memory ) { 
      assert(false);
      return;
    }
  }

  /// @notice compares the result of mul with the result of mulu
  /// @dev x operates over all reals, y over all positive integers
  /// @param x 64.64 signed fixed, is forced positive if not already
  /// @param y positive integer
  function compareMulWithMulu(int128 x, uint256 y) public {
    if(x < 0){
      x = -x;
    }
    x = _clampFixedToValidRange(x);
    y = _clampIntegerToValidRange(y);
    int128 y_fixed = fromUInt(y);
    emit Value2("y_fixed", y_fixed);

    // may revert, not a big deal
    int128 prod1 = mul(x,y_fixed);
    emit Value2("prod1", prod1);
    uint256 prod1_integer = toUInt(prod1);
    emit Value4("prod1_integer", prod1_integer);


    // must not revert
    try this.mulu(x, y) returns (uint256 prod2) { 
      emit Value4("prod2", prod2);

      uint256 error = _calculateError(prod2, prod1_integer);
      emit Value4("error", error);
      assert(error == 0);
      return;
    } catch (bytes memory ) { 
      assert(false);
      return;
    }
  }

  /// @notice Covers mulu operations involving the high bits. Integers only.
  /// @param x integer that will be turned into a fixed.
  /// @param y positive integer. No other constraints.
  function compareMuluWithNormalMul(uint256 x, uint256 y) public {
    x = _clampIntegerToValidRange(x);
    int128 x_fixed = fromUInt(x);
    emit Value2("x_fixed", x_fixed);

    // may revert, not a big deal.
    uint256 prod1 = x * y;
    emit Value4("prod1", prod1);

    // must not revert
    try this.mulu(x_fixed, y) returns (uint256 prod2) { 
      emit Value4("prod2", prod2);

      uint256 error = _calculateError(prod1, prod2);
      emit Value4("error", error);
      assert(error == 0);
      return;
    } catch (bytes memory ) { 
      assert(false);
      return;
    }
  }

  /// @notice compares the output of the square root operation with the power operation (x^2)^(1/2) == x
  /// @dev operates over all valid integers
  /// @param x signed integer, clamped to valid range 
  function compareSqrtPow(int256 x) public {
    x = _clampIntegerToValidRange(x);
    int128 x_fixed = fromInt(x);

    int128 x_squared = pow(x_fixed, 2);
    require(x_squared != 0);

    emit Value2("x_squared", x_squared);

    int128 root = sqrt(x_squared);
    emit Value2("root", root);
    int128 error = _calculateErrorFixed(abs(x_fixed), root);

    // we expect no error when powering/sqrting integers
    emit Value2("error", error);
    assert(error == 0);
  }


  /// @notice compares the output of the square root operation with the power operation  (x^2)^(1/2) == x
  /// @dev operates over all reals
  /// todo: needs a way to figure out error estimating function
  /*
  function compareSqrtPowDecimals(int128 x) public {
    x = _clampFixedToValidRange(x);(x);
    emit Value2("x", x);
    int128 x_integer = toInt(x);
    require(x_integer != 0);
    require(x_integer > 1 || x_integer < -1);
    emit Value2("x_integer", x_integer);

    // sqrt(x^2)
    int128 x_squared = pow(x, 2);
    require(x_squared != 0);
    require(x_squared > 1 || x_squared < -1);

    emit Value2("x_squared", x_squared);

    int128 root = sqrt(x_squared);
    emit Value2("root", root);

    int128 x_compare = x < 0 ? -x : x;
    int128 error = _calculateErrorFixed(x_compare, root);
    emit Value2("error", error);

    // now work backwards. sqrt(x)^2 
    int128 x_root_2 = sqrt(x);
    emit Value2("x_root_2", x_root_2);
    int128 x_power_2 = pow(x_root_2, 2);
    emit Value2("x_power_2", x_power_2);
    int128 error2 = _calculateErrorFixed(x_compare, x_power_2);
    emit Value2("error2", error2);    
    assert((error == 0 && error2 == 0) || error == error2);
  }
  */

  /// @notice Validates the output of the gavg function by comparing its output with the geometric average calculated via arithmetic mean of logarithms.
  /// todo: figure out how to model the error at extremely tiny x,y
  /// @param x fixed integer which will be clamped to valid range
  /// @param y fixed integer which will be clamped to valid range
  /// Allowable error is 1 part in 1000000000 (chosen arbitrarily)
  function compareGavgWithLogMean(int128 x, int128 y) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    require(abs(x) >= one && abs(y) >= one);
    int256 m = int256 (x) * int256 (y);
    require (m >= 0);
    require (m < 0x4000000000000000000000000000000000000000000000000000000000000000);

    emit Value2("x", x);
    emit Value2("y", y);

    // first calculate the geometric mean using the arithmetic mean of logarithms
    int128 ln_x = ln(x);
    int128 ln_y = ln(y);
    emit Value2("ln_x", ln_x);
    emit Value2("ln_y", ln_y);
    require(ln_x != 0 && ln_y != 0);

    int128 avg_of_logs = avg(ln_x, ln_y);
    emit Value2("avg_of_logs", avg_of_logs);

    int128 geo_mean_from_logarithms = exp(avg_of_logs);
    emit Value2("geo_mean_from_logarithms", geo_mean_from_logarithms);

    try this.gavg(x,y) returns (int128 geo_mean) {
      emit Value2("geo_mean", geo_mean);

      int128 error = _calculateErrorFixed(geo_mean, geo_mean_from_logarithms);
      emit Value2("error", error);

      int128 maxToleratedError;
      if(abs(x) < abs(y)){
        maxToleratedError = div(abs(x),fromInt(1000000000));
      } else {
        maxToleratedError = div(abs(y),fromInt(1000000000));
      }
      if(maxToleratedError == 0) {
        maxToleratedError = 1;
      }
      emit Value2("maxToleratedError", maxToleratedError);
      assert(error <= maxToleratedError);
    } catch(bytes memory ) {
      assert(false);
    }
  }

  /// @notice compare exp(x) with the infinite series definition of exp(x). 
  /// @dev allowable error is 1 part in 1/(10 * epsilon)
  /// @param x fixed integer which will be clamped to the valid range.
  function compareNaturalExponentialWithLimit(int128 x) public {
    x = _clampFixedToValidRange(x);

    int128 exp_x = exp(x);
    emit Value2("exp_x", exp_x);

    int128 summation = 0;
    uint256 n = 0;

    int128[23] memory factorial  = [
      int128(1),
      int128(1),
      int128(2),
      int128(6),
      int128(24),
      int128(120),
      int128(720),
      int128(5040),
      int128(40320),
      int128(362880),
      int128(3628800),
      int128(39916800),
      int128(479001600),
      int128(6227020800),
      int128(87178291200),
      int128(1307674368000),
      int128(20922789888000),
      int128(355687428096000),
      int128(6402373705728000),
      int128(121645100408832000),
      int128(2432902008176640000),
      int128(51090942171709440000),
      int128(1124000727777607680000)
    ];

    // calculate the infinite series of e^x until we get blown out by precision
    while(true){
      int128 numerator = pow(x, n);
      int128 denominator_fixed = fromInt(factorial[n]);
      //emit Value4("n", n);
      //emit Value2("numerator", numerator);
      //emit Value2("denominator_fixed", denominator_fixed);
      //assert(false);
      int128 term = div(numerator,denominator_fixed);
      if(term == 0 || n > 22){
        emit Value4("terminating summation at n=", n);
        break;
      }
      emit Value2("adding term to summation: ", term);
      summation = add(summation, term);
      n += 1;
    }
    emit Value2("summation result", summation);
    
    int128 error = _calculateErrorFixed(summation, exp_x);
    emit Value2("error", error);

    int128 maxError = mul(abs(exp_x), 10);
    emit Value2("maxError", maxError);
    
    assert(error <= maxError);
  }

  // div

  /// @notice fuzzes div with 0/x = 0
  /// @dev operates over all valid reals fv
  function testZeroDivision(int128 x) public {
    x = _clampFixedToValidRange(x);

    int128 result = div(zero, x);
    assert(result == zero);
  }

  /// @notice fuzzes div with x/1 = x
  /// @dev operates over all valid reals
  function testDivisionIdentity(int128 x) public {
    x = _clampFixedToValidRange(x); 

    int128 result = div(x, one);
    assert(result == x);
  }

  /// @notice fuzzes div with x/x = 1
  /// @dev operates over all valid reals
  function testDivisionIdentity2(int128 x) public {
    x = _clampFixedToValidRange(x); 

    int128 result = div(x, x);
    assert(result == one);
  }

  /// @notice fuzzes div with x/y != y/x when y != x
  /// @dev operates over all valid reals with the exclusion of 0
  function testDivNotAssociative(int128 x, int128 y) public {
    require(x != 0 && y != 0);
    x = _clampFixedToValidRange(x); 
    y = _clampFixedToValidRange(y); 

    require(abs(x) != abs(y));

    int128 result1 = div(x,y);
    int128 result2 = div(y,x);
    assert(result1 != result2);
  }

  /// @notice attempts to generate an overflow on div. Fails if no revert.
  /// @dev operates over integers
  function testDivMustOverflow(int256 x, int256  y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);

    require(x / y > fixed_max_integer);

    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);
    emit Value2("x_fixed", x_fixed);
    emit Value2("y_fixed", y_fixed);

    try this.div(x_fixed, y_fixed) returns (int128 q) { 
      emit Value2("quotient", q);
      assert(false);
      return;
    } catch (bytes memory ) { 
      return;
    }
  }

  // todo: broken
  /// @notice attempts to generate an underflow on div. Fails if no revert.
  /// @dev operates over integers
  /*
  function testDivMustUnderflow(int256 x, int256  y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);

    require(x / y < fixed_min_integer);

    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);
    emit Value2("x_fixed", x_fixed);
    emit Value2("y_fixed", y_fixed);

    try this.div(x_fixed, y_fixed) returns (int128 q) { 
      emit Value2("quotient", q);
      assert(false);
      return;
    } catch (bytes memory ) { 
      return;
    }
  }
  */

  /// @notice tests that div does not revert when result is in range
  /// @dev operates over integers
  function testDivMustNotOverflowOrUnderflow(int256 x, int256 y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);

    require(x / y <= fixed_max_integer);
    require(x / y >= fixed_min_integer);

    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);
    emit Value2("x_fixed", x_fixed);
    emit Value2("y_fixed", y_fixed);

    try this.div(x_fixed, y_fixed) returns (int128 q) { 
      return;
    } catch (bytes memory ) { 
      assert(false);
    }
  }

  /// @notice tests that the result of div matches the builtin
  /// @dev operates over integers
  function testDivisionAcrossIntegers(int256 x, int256 y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);

    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);
    emit Value2("x_fixed", x_fixed);
    emit Value2("y_fixed", y_fixed);

    int128 q1 = toInt(div(x_fixed,y_fixed));
    int128 q2 = int128(x / y);
    emit Value2("q1", q1);
    emit Value2("q2", q2);

    int128 error = _calculateErrorFixed(q1, q2);
    emit Value2("error", error);
    assert(error < 2);
  }

  // average

  /// @dev make sure the average function is generating correct results by verifying:
  /// let a = avg(x,y)
  /// assert(distance(x,a) == distance(y,a))
  /// Operates over all reals.
  function testDefinitionOfAverage(int128 x, int128 y) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);

    int128 calced_avg = avg(x,y);

    int128 interval_1;
    int128 interval_2;
    assert((x >= calced_avg && calced_avg >= y) || (y >= calced_avg && calced_avg >= x) );
    if(x > calced_avg) {
      interval_1 = sub(x, calced_avg);
      interval_2 = sub(calced_avg, y);
    } else {
      interval_1 = sub(y, calced_avg);
      interval_2 = sub(calced_avg, x);
    }
    int128 error = _calculateErrorFixed(interval_1, interval_2);

    if(error > 1){
      emit Value2("error", error);
      emit Value2("interval 1", interval_1);
      emit Value2("interval 2", interval_2);
      assert(false);
    }
  }

  // abs

  /// @dev make sure abs doesn't revert for numbers within its tolerated range. Operates over all reals.
  function testAbsDoesntRevertOverflow(int128 x) public {
    x = _clampFixedToValidRange(x);
    require(x != fixed_min);
    
    try this.abs(x) returns (int128 x) {
      return;
    } catch (bytes memory ) {
      emit Value3("fixed x", x);
      assert(false);
    }
  }

  /// @dev make sure abs actually does what it says on the label. Operates over integers.
  function testAbsFunctionality(int256 x) public {
    int128 f = fromInt(x);

    int128 abs_f = abs(f);

    if(x >= 0){
      assert(abs_f == f);
    } else {
      int256 convertedBack = toInt(abs_f);
      assert(x * -1  == convertedBack);
    }
  }


  // negation

  /// @dev make sure neg doesn't overflow or underflow when it shouldn't. Operates over all reals.
  function testNegateDoesntOverflowUnderflow(int128 x) public {
    require(x != fixed_min_integer);
    x = _clampFixedToValidRange(x);
    int128 x_fixed = fromInt(x);

    try this.neg(x_fixed) returns (int128 f) {
      return;
    } catch (bytes memory ) {
      emit Value3("fixed x", x);
      assert(false);
    }
  }

  // power

  /// @dev validate that any whole number raised to an even power is positive. Operates over integers.
  function testEvenPowers(int256 x, uint256 y) public {
    x = _clampIntegerToValidRange(x);
    if(y % 2 != 0){
      y += 1;
    }
    require(x != 0);

    int128 p = pow(fromInt(x),y);
    int256 pi = toInt(p);
    assert(pi > 0);
  }

  /// @dev validate that any negative whole number raised to an odd power is negative. Operates over integers.
  function testOddPowers(int256 x, uint256 y) public {
    x = _clampIntegerToValidRange(x);
    if(y % 2 == 0){
      y += 1;
    }
    require(x < 0);

    int128 p = pow(fromInt(x),y);
    int256 pi = toInt(p);
    emit Value3("value", pi);
    assert(pi < 0);
  } 

  /// @dev validate the product of powers property. Checks all reals.
  /// maximum allowable error is 1 part in 1/(5 * epsilon).
  function testProductOfPowers(int128 x, uint256 y, uint256 z) public {
    x = _clampFixedToValidRange(x);
    int128 p1 = pow(x, y);
    emit Value2("p1", p1);
    int128 p2 = pow(x, z);
    emit Value2("p2", p2);

    int128 prod1 = mul(p1, p2);
    emit Value2("prod 1", prod1);

    uint256 e1 = y + z;
    emit Value4("e1", e1);
    int128 prod2 = pow(x, e1);
    emit Value2("prod 2", prod2);

    int128 error = _calculateErrorFixed(prod1, prod2);
    emit Value2("error", error);

    int128 maxError = mul(abs(p2), 5);
    emit Value2("maxError", maxError);

    assert(error <= maxError);
  }

  /// @dev test power of powers property. Checks all reals.
  /// maximum allowable error is 1 part in 1/(20 * epsilon).
  function testPowerOfPowers(int128 x, uint256 y, uint256 z) public {
    x = _clampFixedToValidRange(x);
    int128 p1 = pow(x, y);
    emit Value2("p1", p1);
    int128 p2 = pow(p1, z);
    emit Value2("p2", p2);

    uint256 powerProd = y * z;
    emit Value4("powerProd", powerProd);
    int128 p3 = pow(x, powerProd);
    emit Value2("p3", p3);

    int128 error = _calculateErrorFixed(p2, p3);
    emit Value2("error", error);

    int128 maxError = mul(abs(p2), 10) * mul(abs(p1), 10);


    int128 p1Error = mul( abs(fromUInt(y)), div(1, x));
    emit Value2("p1Error", p1Error);

    int128 p2Error = mul( abs(p1), 1);
    emit Value2("p2Error", p2Error);

    emit Value2("maxError", maxError);

    assert(error <= maxError);
  }

  /// @dev test power of integers is correct. Operates over integers.
  function testPowerOfIntegers(int256 x, uint256 y) public {
    x = _clampIntegerToValidRange(x);
    int128 x_fixed = fromInt(x);
    int128 power_fixed = pow(x_fixed, y);

    int256 power = x ** y;
    
    assert(power == toInt(power_fixed));
  }

  /// @dev make sure power function doesn't overflow when it's not supposed to. Operates over integers.
  function testPowerShouldntOverflowUnderflow(int256 x, uint256 y) public {
    x = _clampIntegerToValidRange(x);
    int128 x_fixed = fromInt(x);

    int256 power = x ** y;
    require(power <= fixed_max_integer);
    require(power >= fixed_min_integer);

    try this.pow(x_fixed, y) returns (int128 power_fixed) {
      assert(power_fixed <= fixed_max);
      assert(power_fixed >= fixed_min);
      return;
    } catch (bytes memory ) {
        emit Value3("fixed", x);
        assert(false);
    }
  }
  
  /// @dev make sure power function reverts when there's an overflow. Operates over integers.
  function testPowerMustOverflowUnderflow(int256 x, uint256 y) public {
    x = _clampIntegerToValidRange(x);
    int128 x_fixed = fromInt(x);

    int256 power = x ** y;
    require(power > fixed_max_integer || power < fixed_min_integer);

    try this.pow(x_fixed, y) returns (int128 power_fixed) {
      emit Value3("fixed", power_fixed);
      assert(false);
    } catch (bytes memory ) {
      return;
    }
  }


  // fromint/toint
   
  /// @dev test that whole numbers don't get quantized when being converted to 64.64
  function testFromIntQuantization(int256 x) public {
    int128 x1 = fromInt(x);
    int256 x2 = toInt(x1);
    assert(x2 == x);
  }

  /// @dev make sure fromInt doesn't overflow or underflow
  function testFromIntDoesntOverflowUnderflow(int256 x) public {
    require(x <= fixed_max_integer && x>= fixed_min_integer);

    try this.fromInt(x) returns (int128 f) {
      assert(f <= fixed_max);
      return;
    } catch (bytes memory ) {
      emit Value3("fixed", x);
      assert(false);
    }
  }

  /// @dev make sure fromInt reverts when it overflows/underflows
  function testFromIntShouldOverflowUnderflow(int256 x) public {
    require(x > fixed_max_integer || x < fixed_min_integer);

    try this.fromInt(x)returns (int128 s) {
      emit Value3("x", x);
      emit Value2("s", s);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }


  // fromUInt/toUInt 

  /// @dev test that whole numbers don't lose precision when being converted to 64.64 via fromUInt
  function testFromUIntQuantization(uint256 x) public {
    int128 x1 = fromUInt(x);
    uint64 x2 = toUInt(x1);
    assert(x2 == x);
  }

  /// @dev make sure fromUInt doesn't overflow or underflow
  function testFromUIntDoesntOverflowUnderflow(uint256 x) public {
    require(x <= uint256(int256(fixed_max_integer)));
    // todo: make sure this hits 0 case.

    try this.fromUInt(x) returns (int128 f) {
      assert(f <= int128(fixed_max));
      return;
    } catch (bytes memory ) {
      emit Value4("fixed", x);
      assert(false);
    }
  }

  /// @dev make sure toUInt doesn't overflow or underflow when it shouldnt
  function testToUIntDoesntOverflowUnderflow(uint256 x) public {
    require(x <= 0 && x <= uint256(int256(fixed_max_integer)));

    int128 f = this.fromUInt(x);

    try this.toUInt(f) returns (uint64 i) {
      return;
    } catch (bytes memory ) {
      assert(false);
    }
  }

  /// @dev make sure fromUInt reverts when it overflows/underflows
  function testFromUIntShouldOverflowUnderflow(uint256 x) public {
    require(x >  uint256(int256((fixed_max_integer) )));

    try this.fromUInt(x)returns (int128 s) {
      emit Value4("x", x);
      emit Value2("s", s);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }

  /// @dev make sure toUInt reverts when converting negative fixed decimals
  function testFromUIntRevertsOnNegative(int256 x) public {
    require(x != 0);
    if(x > 0){
      x = -x;
    }

    int128 f = this.fromInt(x);
    try this.toUInt(f) returns (uint64 i) {
      emit Value5("output", i);
      assert(false);
    } catch(bytes memory) {
      return;
    }
  }
  
  // addition
  
  /// @dev test the associative property. x+y+z = y+x+z = z+x+y. Operates over reals.
  function testAddAssociative(int128 x, int128 y, int128 z) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    z = _clampFixedToValidRange(z);

    int128 a1 = add(x,y);
    int128 a2 = add(a1, z);

    int128 b1 = add(x,z);
    int128 b2 = add(b1, y);

    int128 c1 = add(y,z);
    int128 c2 = add(c1, x);

    assert(a2 == b2);
    assert(b2 == c2);
  }

  /// @dev test the addition communicative property. x + y = y + x. Operates over reals.
  function testAddCommunicative(int128 x, int128 y) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    int128 a = add(x,y);
    int128 b = add(y,x);

    assert(a == b);
   }

  /// @dev test the addition identity property. x + 0 = x. Operates over reals.
  function testAddIdentity(int128 x) public {
    x = _clampFixedToValidRange(x);
    int128 a = add(x,0);
    assert(a == x);
  }  

  /// @notice make sure add doesn't overflow when it shouldn't. Operates over reals.
  /// @dev this invariant attempts 2 add operations to cover the full range of possible results
  /// for all inputs x, x+0 is tested
  /// for negative inputs, x + fixed_max is tested
  /// for positive inputs, x + fixed_min is tested
  function testAddDoesntOverflow(int128 x) public {
    x = _clampFixedToValidRange(x);
    require(x != 0);
    emit Value2("x", x);

    try this.add(x,0) returns (int128 sum) {
      assert(sum <= fixed_max);
    } catch (bytes memory ) {
      emit Value2("exception thrown when adding to ", 0);
      assert(false);
    }

    if(x > 0){
      try this.add(x,fixed_min) returns (int128 sum) {
        assert(sum <= fixed_max);
        return;
      } catch (bytes memory ) {
        emit Value2("exception thrown when adding to ", fixed_min);
        assert(false);
      }
    } else {
      try this.add(x,fixed_max) returns (int128 sum) {
        assert(sum <= fixed_max);
        return;
      } catch (bytes memory ) {
        emit Value2("exception thrown when adding to ", fixed_max);
        assert(false);
      }
    }
  }

  /// @notice make sure add overflows + reverts when it should. Operates over reals.
  function testAddRevertsOnOverflow(int128 x) public {
    x = _clampFixedToValidRange(x);
    require(x > 0);

    try this.add(x,fixed_max) returns (int128 sum) {
      emit Value2("x", x);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }

  /// @dev make sure add doesn't underflow when it shouldn't. Operates over reals.
  function testAddDoesntUnderflow(int128 x, int128 y) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    require(x+y >= fixed_min );

    try this.add(x,y) returns (int128 sum) {
      assert(sum >= fixed_min);
      return;
    } catch (bytes memory ) {
      emit Value2("x", x);
      emit Value2("y", y);
      assert(false);
    }
  }

  /// @dev make sure add underflows + reverts when it should. Operates over reals.
  function testAddRevertsOnUnderflow(int128 x) public {
    x = _clampFixedToValidRange(x);
    emit Value2("x", x);
    require(x < 0);

    try this.add(x,fixed_min) returns (int128 sum) {
      emit Value2("sum", sum);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }

  /// @dev make sure add's output is correct for integers. Operates over integers.
  function testAddIntegers(int256 x, int256 y) public {
    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);

    int128 sum_fixed = add(x_fixed, y_fixed);
    int256 sum = x + y;
    assert(sum == toInt(sum_fixed));
  }
  

  // subtraction
  
  
  /// @dev test: x - 0 = x. Operates over reals.
  function testSubtractIdentity(int128 x) public {
    x = _clampFixedToValidRange(x);
    int128 a = sub(x,0);
    assert(a == x);
  }

  /// @dev test: x - x = 0. Operates over reals.
  function testSubtractIdentity2(int128 x) public {
    x = _clampFixedToValidRange(x);
    int128 a = sub(x,x);
    assert(a == 0);
  }

  /// @dev test the communicative property not working. x-y != y-x. Operates over reals.
  function testSubtractCommunicative(int128 x, int128 y) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    require(x != y);
    int128 s1 = sub(x,y);
    int128 s2 = sub(y,x);
    assert(s1 != s2);
  }

  /// @dev test the associative properties of subtraction. x-y-z != y-x-z != z-x-y. Operates over reals.
  function testSubtractAssociative(int128 x, int128 y, int128 z) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    z = _clampFixedToValidRange(z);
    require(x != y);
    require(y != z);
    require(x != z);

    int128[3][3] memory permutations = [
      [x,y,z],
      [y,x,z],
      [z,x,y]
    ];
    
    int128[] memory results = new int128[](3);

    for(uint i=0; i<3; i++){
      int128 a1 = sub(permutations[i][0],permutations[i][1]);
      int128 a2 = sub(a1,permutations[i][2]);
      results[i] = a2;
    }

    assert(results[0] != results[1]);
    assert(results[1] != results[2]);
    assert(results[0] != results[2]);
  }



  /// @dev make sure subtract doesn't overflow or underflow when it shouldn't. Operates over reals.
  function testSubDoesntOverflowUnderflow(int128 x, int128 y) public {
    x = _clampFixedToValidRange(x);
    y = _clampFixedToValidRange(y);
    require(x - y >= fixed_min && x - y <= fixed_max);

    try this.sub(x, y) returns (int128 f) {
      assert(f <= fixed_max);
      assert(f >= fixed_min);
      return;
    } catch (bytes memory ) {
      emit Value3("fixed x", x);
      emit Value3("fixed y", y);
      assert(false);
    }
  }

  /// @dev make sure subtract reverts when it overflows. Operates over reals.
  function testSubShouldOverflow(int128 x) public {
    x = _clampFixedToValidRange(x);
    emit Value2("x", x);
    require(x < 0);

    try this.sub(fixed_max, x) returns (int128 s) {
      emit Value2("s",s);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }

    /// @dev make sure subtract reverts when it underflows. Operates over reals.
  function testSubShouldUnderflow(int128 x) public {
    x = _clampFixedToValidRange(x);
    emit Value2("x", x);
    require(x > 0);

    try this.sub(fixed_min, x) returns (int128 s) {
      emit Value2("s",s);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }

  /// @dev make sure sub's output is correct for integers. Operates over integers.
  function testSubIntegers(int256 x, int256 y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);

    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);

    int128 difference_fixed = sub(x_fixed, y_fixed);
    int256 difference = x - y;
    assert(difference == toInt(difference_fixed));
  }
  


  // mul

  /// @dev test x * 0 = 0. Operates over reals.
  function testMultiplyZero(int128 x) public {
    int128 a = mul(x,0);
    emit Value2("a", a);
    assert(a == 0);
  }

  /// @dev test mult identity x * 1 = x
  function testMultiplyIdentity(int128 x) public {
    int128 a = mul(x,one);
    emit Value2("a", a);
    assert(a == x);
  }

  /// @dev test the associative property of multiplication.  Operates over integers.
  function testMultiplyAssociative(int256 x, int256 y, int256 z) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);
    z = _clampIntegerToValidRange(z);
    emit Value3("x", x);
    emit Value3("y", y);
    emit Value3("z", z);

    // only testing properties of whole numbers here
    int128 x1 =  fromInt(x);
    int128 y1 =  fromInt(y);
    int128 z1 =  fromInt(z);

    int128 a1 = mul(x1,y1);
    int128 a2 = mul(a1, z1);

    int128 b1 = mul(z1,x1);
    int128 b2 = mul(b1, y1);

    int128 c1 = mul(y1,x1);
    int128 c2 = mul(c1, z1);

    emit Value2("a2", a2);
    emit Value2("b2", b2);
    emit Value2("c2", c2);

    assert(a2 == b2);
    assert(b2 == c2);
   }

  /// @dev test the communicative property of multiplication x * y = y * x.  Operates over reals.
  function testMultiplyCommunicative(int128 x, int128 y) public {
      x = _clampFixedToValidRange(x);
      y = _clampFixedToValidRange(y);
      emit Value2("x", x);
      emit Value2("y", y);

      int128 a = mul(x,y);
      int128 b = mul(y,x);
      emit Value2("a", a);
      emit Value2("b", b);
      assert(a == b);
   }

  /// @dev make sure mul doesn't overflow or underflow when it shouldn't. Operates over integers.
  function testMulDoesntOverflowUnderflow(int256 x, int256 y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);
    emit Value3("x", x);
    emit Value3("y", y);

    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);
    emit Value3("fixed x", x);
    emit Value3("fixed y", y);

    require(int256(x) * y >= fixed_min_integer && int256(x) * y <= fixed_max_integer);

    try this.mul(x_fixed, y_fixed) returns (int128 f) {
      assert(f <= fixed_max);
      assert(f >= fixed_min);
      return;
    } catch (bytes memory ) {
      assert(false);
    }
  }

  /// @dev make sure mul's output is correct for integers
  function testMulIntegerProduct(int256 x, int256 y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);
    emit Value3("x", x);
    emit Value3("y", y);
    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);  

    int128 fixedProduct = mul(x_fixed, y_fixed);
    int256 product = x * y;
    emit Value3("fixedProduct", toInt(fixedProduct));
    emit Value3("product", product);

    assert(product == toInt(fixedProduct));
  }

  /// @dev make sure mul reverts when it overflows/underflows. Operates over integers.
  function testMulShouldOverflowUnderflow(int256 x, int256 y) public {
    x = _clampIntegerToValidRange(x);
    y = _clampIntegerToValidRange(y);
    emit Value3("x", x);
    emit Value3("y", y);
    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);  

    require(int256(x) * y < fixed_min_integer || int256(x) * y > fixed_max_integer);

    try this.mul(x_fixed, y_fixed)returns (int128 s) {
      emit Value3("s", s);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }

  /// @notice test add  x+y-x = y
  function testAddSubtractInverse(int128 x, int128 y) public {
    int128 sum = add(x,y);

    int128 diff1 = sub(sum,y);
    assert(diff1 == x);

    int128 diff2 = sub(sum,x);
    assert(diff2 == y);
  }

  /// @notice tests muli using x * 0 = 0. All reals.
  function testMuliIdentity(int128 x) public {
    int256 a = muli(x,0);
    assert(a == 0);
  }

  /// @notice tests muli using x * 1 = x. All reals.
  function testMuliIdentity2(int128 x) public {
    int256 a = muli(x,one);
    assert(a == x);
  }

  /// @notice tests muli associative property a * b * c = b * a * c = c * a * b. All reals.
  function testMuliAssociative(int128 x, int128 y, int128 z) public {
    // only testing properties of whole numbers here
    int128 x1 =  fromInt(x);
    int128 y1 =  fromInt(y);
    int128 z1 =  fromInt(z);

    int256 a1 = muli(x1,y);
    int128 a1_f = fromInt(a1);
    int256 a2 = muli(a1_f, z1);

    int256 b1 = muli(z1,x);
    int128 b1_f = fromInt(b1);
    int256 b2 = muli(b1_f, y1);

    int256 c1 = muli(y1,x);
    int128 c1_f = fromInt(c1);
    int256 c2 = muli(c1_f, z1);

    assert(a2 == b2);
    assert(b2 == c2);
   }

  /// @notice tests muli communicative property. x * y = y * x
  function testMuliCommunicative(int128 x, int128 y) public {
    int256 a = muli(x,y);
    int256 b = muli(y,x);

    assert(a == b);
   }

  /// @notice make sure muli reverts when its result causes an overflow
  function testMuliOverflow1(int128 x, int256 y) public {
    require(x > 1);
    require(y > 1);

    // only testing whole numbers
    int128 x1 = fromInt(x);
  
    int256 product = muli(x1,y);
    assert(product > x);
    assert(product > y);
  }

  /// @notice make sure muli reverts when its result is underflow
  function testMuliUnderflow(int128 x, int256 y) public {
    require(x < -1);
    require(y > 1);

  // only testing whole numbers
    int128 x1 = fromInt(x);

    int256 product = muli(x1,y);
    assert(product < y * -1);
    assert(product < x);
  }


  /*
  /// @dev make sure mul reverts when it overflows/underflows
  /// broken
  function testMulShouldOverflowUnderflow2(int128 x, int128 y, uint64 decimal) public {
    int128 x_fixed = fromInt(x);
    int128 y_fixed = fromInt(y);  

    require(int256(x) * y - 1 < fixed_min_integer || int256(x) * y + 1 > fixed_max_integer);

    x_fixed = x_fixed & int64(decimal);

    try this.mul(x_fixed, y_fixed)returns (int128 s) {
      emit Value2("x", x);
      emit Value2("y", y);
      assert(false);
      return;
    } catch (bytes memory ) {
      return;
    }
  }
  */

  /*
  /// @dev operates over all valid reals
  function testDivMustOverflow2(int128 x, uint64  extraPush) public {
    ///////
    require(x != 0);
    extraPush = 1;
    require(extraPush != 0);
    
    int128 extraPushInt128 = int128(uint128(extraPush));
    
    x = _clampFixedToValidRange(x);

    // create a final_denominator that will trigger an overflow;
    //x = fromInt(1);
    int128 temp = div(fixed_max, x);
    int128 denominator = ABDKMath64x64.inv(temp);
    emit Value2("temp", temp);
    
    require(denominator != 0);
    extraPushInt128 = extraPushInt128 % abs(denominator);

    int128 nudged_denominator;
    if(denominator > 0){
      nudged_denominator = denominator-extraPushInt128;
    } else {
      nudged_denominator = denominator+extraPushInt128;
    }

    try this.div(x, nudged_denominator) returns (int128 f) { 
      emit Value2("x_fixed", x);
      emit Value2("denominator", denominator);
      emit Value2("nudged_denominator", nudged_denominator);
      assert(false);
      return;
    } catch (bytes memory ) { 
      
    }

    try this.div(x, denominator) returns (int128 f) { 
      return;
    } catch (bytes memory ) { 
      emit Value2("x_fixed", x);
      emit Value2("denominator", denominator);
      emit Value2("nudged_denominator", nudged_denominator);
      assert(false);
    }

    // uint256 / max_uint_256 = future_denominator

    // adj_denominator = future_denominator - skew
  }
  */

  /*
  /// @notice verifies from128x128 will revert if passed a value that causes overflow
  /// @dev operates over all reals
  /// todo: broken
  function testfrom128x128RevertsOnOverflow(uint64 push) public {
    require(push != 0);
    int128 x_fixed_64 = fixed_max;
    int256 x_fixed_128 = to128x128(x_fixed_64);

    int256 push_128 = int256(int128(uint128(push))) << 64;
    emit Value3("push_128", push_128);

    // nudge into error territory
    x_fixed_128 = x_fixed_128 + push_128;

    try this.from128x128(x_fixed_128) returns (int128 fixed_64) { 
      emit Value3("fixed128", x_fixed_128);
      emit Value3("fixed64", fixed_64);
      assert(false);
      return;
    } catch (bytes memory ) { 
      return;
    }
  }

  /// @notice verifies from128x128 will revert if passed a value that causes underflow
  /// @dev operates over all reals
  /// todo: broken
  function testfrom128x128RevertsOnUnderflow(uint64 push) public {
    require(push != 0);
    int128 x_fixed_64 = fixed_min;
    int256 x_fixed_128 = to128x128(x_fixed_64);

    int256 push_128 = int256(int128(uint128(push))) << 64;
    emit Value3("push_128", push_128);

    // nudge into error territory
    x_fixed_128 = x_fixed_128 - push_128;

    try this.from128x128(x_fixed_128) returns (int128 fixed_64) { 
      emit Value3("fixed128", x_fixed_128);
      emit Value3("fixed64", fixed_64);
      assert(false);
      return;
    } catch (bytes memory ) { 
      return;
    }
  }
  */

}