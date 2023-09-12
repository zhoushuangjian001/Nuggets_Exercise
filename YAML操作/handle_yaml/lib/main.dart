import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handle_yaml/fam/fam.dart';
import 'package:yaml/yaml.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  rootBundle.loadStructuredData<YamlList>(FamManager.yFile, (content) async {
    return loadYamlStream(content);
  }).then((YamlList yamlList) {
    print(yamlList.value);
  });
}

void loadYamlNodeX() {
  rootBundle.loadStructuredData<YamlNode>(FamManager.yFile, (content) async {
    return loadYamlNode(content);
  }).then((YamlNode yamlNode) {
    print(yamlNode.value);
  });
}

void loadYamlDocumentsX() {
  rootBundle.loadStructuredData<List<YamlDocument>>(FamManager.yFile, (content) async {
    return loadYamlDocuments(content);
  }).then((List<YamlDocument> yamlDocuments) {
    print(yamlDocuments.first.contents);
  });
}

void loadYamlDocumentX() {
  rootBundle.loadStructuredData<YamlDocument>(FamManager.yFile, (content) async {
    return loadYamlDocument(content);
  }).then((YamlDocument yamlDocument) {
    print(yamlDocument.contents);
  });
}

void loadYamlX() {
  rootBundle.loadStructuredData<YamlMap>(FamManager.yFile, (content) async {
    return loadYaml(content);
  }).then((YamlMap yamlMap) {
    print(yamlMap.nodes);
  });
}

void loadStructuredData() {
  rootBundle.loadStructuredData(FamManager.yFile, (content) async => content).then((value) {
    print(value);
  });
}

void loadBuffer() {
  rootBundle.loadBuffer(FamManager.yFile).then((ImmutableBuffer immutableBuffer) {
    print(immutableBuffer.length);
  });
}

void loadString() {
  rootBundle.loadString(FamManager.yFile).then((String value) {
    print(value);
  });
}

void load() {
  rootBundle.load(FamManager.yFile).then((ByteData byteData) {
    debugPrint('${byteData.lengthInBytes}'); // 3638
    final ByteBuffer byteBuffer = byteData.buffer;
    final String yaml = utf8.decode(byteBuffer.asUint8List());
    debugPrint(yaml);
  });
}
