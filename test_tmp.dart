import 'dart:io';

void main() {
  final file = File('build_output_5.txt');
  if (file.existsSync()) {
    try {
      final bytes = file.readAsBytesSync();
      // Remove nulls which are causing Powershell text truncations
      final clean = bytes.where((b) => b != 0).toList();
      var str = String.fromCharCodes(clean);
      
      final lines = str.split('\n');
      var out = File('clean_analyze.txt').openWrite();
      for (var l in lines) {
        if (l.contains('error') || l.contains('Error') || l.contains('.dart:')) {
           out.writeln(l.trim());
        }
      }
      out.close();
      print('Done');
    } catch (e) {
      print(e);
    }
  }
}
