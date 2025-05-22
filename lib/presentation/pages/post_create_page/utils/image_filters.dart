import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

final boldPop = GroupShaderConfiguration()
  ..add(ContrastShaderConfiguration()..contrast = 1.4)
  ..add(SaturationShaderConfiguration()..saturation = 1.5);

final filmLook = GroupShaderConfiguration()
  ..add(BrightnessShaderConfiguration()..brightness = 0.05)
  ..add(ContrastShaderConfiguration()..contrast = 1.15)
  ..add(SaturationShaderConfiguration()..saturation = 0.95)
  ..add(NoneShaderConfiguration());

final pinkMoodFilter = GroupShaderConfiguration()
  ..add(BrightnessShaderConfiguration()..brightness = 0.05)
  ..add(SaturationShaderConfiguration()..saturation = 1.3)
  ..add(ContrastShaderConfiguration()..contrast = 1.1)
  ..add(HueShaderConfiguration()..hueAdjust = 340.0);

final moodyBW = GroupShaderConfiguration()
  ..add(GrayscaleShaderConfiguration())
  ..add(ContrastShaderConfiguration()..contrast = 1.3)
  ..add(BrightnessShaderConfiguration()..brightness = -0.1)
  ..add(NoneShaderConfiguration());

final coolBlue = GroupShaderConfiguration()
  ..add(BrightnessShaderConfiguration()..brightness = -0.05)
  ..add(ContrastShaderConfiguration()..contrast = 1.2)
  ..add(SaturationShaderConfiguration()..saturation = 0.9)
  ..add(HueShaderConfiguration()..hueAdjust = 20.0);

final warmVintage = GroupShaderConfiguration()
  ..add(BrightnessShaderConfiguration()..brightness = 0.1)
  ..add(ContrastShaderConfiguration()..contrast = 1.1)
  ..add(SaturationShaderConfiguration()..saturation = 1.2)
  ..add(ColorMatrixShaderConfiguration()
    ..colorMatrix = Matrix4.fromList([
      1.1, 0.05, 0.0, 0,
      0.0, 1.05, 0.05, 0,
      0.05, 0.0, 1.0, 0,
      0.0, 0.0, 0.0, 1,
    ])
    ..intensity = 1.0);

GroupShaderConfiguration defaultFilter = GroupShaderConfiguration()
  ..add(NoneShaderConfiguration())
  ..add(NoneShaderConfiguration());

final filterPresets = {
  'default' : defaultFilter,
  'Bold Pop': boldPop,
  'Film Look': filmLook,
  'Pink Mood': pinkMoodFilter,
  'Moody B&W': moodyBW,
  'Cool Blue': coolBlue,
  'Warm Vintage': warmVintage,
};