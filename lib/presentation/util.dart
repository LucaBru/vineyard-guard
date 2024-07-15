import 'dart:math';

extension TruncateDoubles on double {
  double roundToTwoDecimals() => (this * pow(10, 2)).round() / pow(10, 2);
}
