part of ebisu_web_ui;

/// Example usage of the components
class Example { 
  Example(
    this.id
  ) {
  
  }
  
  /// Id of the example
  final Id id;

// custom <class Example>
// end <class Example>
}

/// Create a Example sans new, for more declarative construction
Example example(Id id) {
  return new Example(id);
}



/// Collection of components wrapped in a library (think http://pub.dartlang.org/packages/widget)
class ComponentLibrary { 
  ComponentLibrary(
    this.id
  ) {
    // custom <ComponentLibrary>

    pubSpec = new PubSpec(id)
      ..addDependency(new PubDependency('browser')..version = ">=0.5.20 <0.5.21")
      ..addDependency(new PubDependency('pathos')..version = ">=0.5.20 <0.5.21")
      ..addDependency(new PubDependency('polymer')..version = "any")
      ..addDependency(new PubDependency('logging')..version = ">=0.5.20 <0.5.21")
      ..addDependency(new PubDependency('logging_handlers')..version = ">=0.5.0+3 <0.5.1");

    // end <ComponentLibrary>
  }
  
  /// Documentation for the component library
  String doc;
  /// Path in which to generate the component library
  String rootPath;
  /// Default access for members
  Access defaultMemberAccess = Access.IA;
  /// Id of the component library
  final Id id;
  /// Pubspec for this component library
  PubSpec pubSpec;
  /// List of support libraries
  List<Library> libraries = [];
  /// List of components in the collection
  List<Component> components;
  bool _finalized = false;
  /// Set to true on finalize
  bool get finalized => _finalized;
  /// List of PubDependency for this component and supporting libraries
  List<PubDependency> dependencies = [];
  /// List of examples for the component library
  List<Example> examples = [];

// custom <class ComponentLibrary>

  void finalize() {
    if(!_finalized) {
      for(Component component in components) {
        component.finalize();
      }
      _finalized = true;
    }
  }

  void generate() {
    finalize();
    components.forEach((component) {
      var name = component.id.capCamel;
      var componentPath = "${rootPath}/${id.snake}/lib/components";
      var htmlFile = "${componentPath}/${component.id.snake}.html";
      htmlMergeWithFile(component.html, htmlFile);

      var definition = '''
import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";
${component.imports.map((comp) => Library.importStatement(comp)).join('\n')}

final _logger = new Logger("${id}");


${component.implClass.define()}
${component.supportClasses.map((c) => c.define()).toList().join('\n')}

${customBlock(id.snake)}
''';
      var dartFile = "${componentPath}/${component.id.snake}.dart";
      mergeWithFile(definition, dartFile);

    });


    var buildFile = "${rootPath}/${id.snake}/build.dart";
    mergeWithFile('''
import "dart:io";
import "package:polymer/component_build.dart";

main() {
  build(new Options().arguments, 
    [
      ${examples.map((eg) =>
       '"example/${eg.id.snake}/${eg.id.snake}.html"').join(',\n      ')}
    ]);
}
''', buildFile);

    var cssFile = "${rootPath}/${id.snake}/lib/components/${id.snake}.css";
    List<String> cssEntries = [];
    cssEntries.add(cssCustomBlock('${id} top'));

    components.forEach((component) {
      cssEntries.add('''
[is=x-${component.id.emacs}] {
${indentBlock(cssCustomBlock(component.id.emacs))}
}
''');
    });

    cssEntries.add(cssCustomBlock('${id} bottom'));
    
    cssMergeWithFile(cssEntries.join('\n\n'), cssFile);
    pubSpec.addDependencies(dependencies);
    if(pubSpec.doc == null) 
      pubSpec.doc = doc;

    System sys = new System(id)
      ..rootPath = "${rootPath}/${id.snake}"
      ..libraries = libraries
      ..pubSpec = pubSpec;

    sys.generate();

    // For example codegen - import all components
    List<String> importStatements = 
      components.map((component) => 
          '<link rel="import" href="package:${id.snake}/components/${component.id.snake}.html">').toList();
    importStatements.add('<link rel="stylesheet" href="packages/${id.snake}/components/${id.snake}.css">');

    examples.forEach((example) {
      var exampleHtmlFile = "${rootPath}/${id.snake}/example/${example.id.snake}/${example.id.snake}.html";
      var exampleHtml = '''<!DOCTYPE html>
<html>
  <head>
${indentBlock(importStatements.join('\n'))}  
${indentBlock(htmlCustomBlock('head ${example.id}'))}
  </head>
  <body>
${indentBlock(htmlCustomBlock('body ${example.id}'))}
  </body>
</html>
''';
      htmlMergeWithFile(exampleHtml, exampleHtmlFile);
    });

  }

// end <class ComponentLibrary>
}

/// Declaratively define component to generate its stubbed out support
class Component { 
  Component(
    this.id
  ) {
  
  }
  
  /// Id - used to generate name of component
  Id id;
  /// Description of the component
  String doc;
  /// Dom element or other component being extended
  String extendsElement = "div";
  /// Class implementing this component - currently will extend WebComponent
  Class implClass;
  /// Any additional support classes required to implement this component
  List<Class> supportClasses = [];
  /// How to construct the component (convention handles unless exceptional case)
  String constructor;
  /// If true styles from document apply to control
  bool applyAuthorStyles = true;
  /// The internals of template fragment that will be rendered when the component is initialized
  String templateFragment = "";
  /// Dart imports required by the component
  List<String> imports = [];
  /// Component imports required by the component
  List<String> htmlImports = [];
  String _name;
  /// Name as used in the html (i.e. words of name hyphenated
  String get name => _name;
  bool _finalized = false;
  /// Set to true on finalize
  bool get finalized => _finalized;

// custom <class Component>

  void finalize() {
    if(!_finalized) {
      _name = "x-${id.emacs}";
      if(implClass == null) {
        print("Creating impl of type ${id}");
        implClass = new Class(id)
          ..extend = 'CustomElement'
          ..doc = doc;
      }

      // Reuse component doc for implClass
      if(implClass.doc == null) implClass.doc = doc;
      // Ensure implClass is derived from WebComponent (for now)
      if(implClass.extend == null) implClass.extend = 'CustomElement';

      implClass.parent = null;
      supportClasses.forEach((c) => (c.parent = null));

      _finalized = true;
    }
  }

  String get html {
    String htmlImportsBlock = indentBlock(htmlImports.map((i) => 
            '<link rel="import" href=${importUri(i)}>').toList().join('\n'));

    return '''<!DOCTYPE html>
<html>
  <head>
${indentBlock(htmlImportsBlock, '    ')}
${indentBlock(htmlCustomBlock('${id} head'), '    ')}
  </head>
  <body>
    <element name="${name}" extends="${new Id(extendsElement).emacs}" constructor="${id.capCamel}" apply-author-styles>
      <template>
${indentBlock(templateFragment, '        ')}
${indentBlock(htmlCustomBlock('${id} template'), '        ')}
      </template>
      <script type="application/dart" src="${id.snake}.dart"></script>
    </element>
  </body>
</html>
''';
  }

// end <class Component>
}
// custom <part component>

ComponentLibrary componentLibrary(String _id) => new ComponentLibrary(id(_id));
Component component(String _id) => new Component(id(_id));

// end <part component>

