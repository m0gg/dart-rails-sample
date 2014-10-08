library benchmark;

import 'package:rails_ujs/rails_ujs.dart';

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

part 'lib/benchmark.dart';
part 'lib/benchmarkresult.dart';
part 'lib/benchmark_arith.dart';
part 'lib/benchmark_io.dart';
part 'lib/benchmark_json.dart';

RailsUjs ujsHelper;

DivElement content, seed_container;
ParagraphElement result_info;
CheckboxInputElement arithmetic, arithmeticSIMD, io, json;
TextAreaElement export_text;
List<BenchmarkResult> results;
Storage store;

void main() {
  ujsHelper = new RailsUjs();
  store = window.localStorage;
  store.clear();
  content = querySelector("#content_container");
  seed_container = querySelector('#seed_container');
  result_info = querySelector("#results");
  arithmetic = querySelector("#arithmetic");
  arithmeticSIMD = querySelector("#arithmeticSIMD");
  json = querySelector("#json");
  io = querySelector("#io");
  export_text = querySelector("#export_text");
  results = new List<BenchmarkResult>();

  arithmetic.onChange.listen((event) {
    if(event.target.checked) {
      io.disabled = false;
      json.disabled = false;
    } else {
      io.disabled = true;
      json.disabled = true;
    }
  });

  querySelector("#start_button")
    ..onClick.listen(startBenchmark);
  querySelector("#export_button")
    ..onClick.listen(sendExport);
}

void startBenchmark([dynamic event]) {
  if(arithmetic.checked) {
    ArithmeticBenchmark b = new ArithmeticBenchmark();
    for(int i = 0; i < 10; i++) {
      b.runAsync()
        ..then((result) {
        benchmark_finish('Arithmetic $i', result);
        if(io.checked) {
          IOWriteBenchmark x = new IOWriteBenchmark(store, result.returnValue.toList(growable: false));
          x.runAsync().then((result2) {
            benchmark_finish('I/O $i', result2);
            IOReadBenchmark xv = new IOReadBenchmark(result2.returnValue);
            xv.runAsync().then((result3) {
              benchmark_finish('IO Read $i', result3);
            });
          });
        }
        if(json.checked) {
          JSONEncodeBenchmark x = new JSONEncodeBenchmark(result.returnValue.toList(growable: false));
          x.runAsync().then((result2) {
            benchmark_finish('JSON Encode $i', result2);
            JSONDecodeBenchmark xv = new JSONDecodeBenchmark(result2.returnValue);
            xv.runAsync().then((result3) {
              benchmark_finish('JSON Decode $i', result3);
            });
          });
        }
      });
    }
  }
  if(arithmeticSIMD.checked) {
    ArithmeticSIMDBenchmark bs = new ArithmeticSIMDBenchmark();
    for(int i = 0; i < 10; i++) {
      bs.runAsync()
        ..then((result) {
        benchmark_finish('ArithmeticSIMD $i', result);
      });
    }
  }
}

void addResult(BenchmarkResult res) {
  results.add(res);
  Duration sum = Duration.ZERO;
  results.forEach((res) => sum += res.runtime);
  Duration mean = sum ~/ results.length;
  result_info.setInnerHtml('mean time: $mean');
}

void sendExport([Event event]) {
  StringBuffer res = new StringBuffer();
  for(BenchmarkResult r in results) {
    if(r is BenchmarkResult<Float32x4List>) {
      res.write(r.export());
    }
  }
  export_text.text = res.toString();
  querySelector("#seed_container").style.display = "block";
}

void benchmark_finish(String index, BenchmarkResult rt) {
  addResult(rt);
  content.appendText('$index :  ${rt.runtime}');
  content.appendHtml('<br />');
}
