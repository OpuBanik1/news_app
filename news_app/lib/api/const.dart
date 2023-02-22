import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String token = 'ae568cd36546427eb4f37151d3d62f22';
const String baseUrl = 'https://newsapi.org/v2/everything?';

myStyle(double size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.nunito(fontSize: size, color: clr, fontWeight: fw);
}
