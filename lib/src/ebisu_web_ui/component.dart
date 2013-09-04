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
      ..addDependency(new PubDependency('browser'))
      ..addDependency(new PubDependency('pathos'))
      ..addDependency(new PubDependency('polymer'))
      ..addDependency(new PubDependency('logging'))
      //      ..addDependency(new PubDependency('logging_handlers')..version = ">=0.5.0+3 <0.5.1");
      ;

    // end <ComponentLibrary>
  }

  /// Documentation for the component library
  String doc;
  /// Prefix associated with all components in the library
  String prefix;
  /// Path in which to generate the component library
  String rootPath;
  /// If true generates entire component library as single file
  bool isInlined = false;
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
        if(component.prefix == null) {
          component.prefix = prefix;
        }
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

@CustomTag("${component.prefixedName}")
${component.implClass.define()}
${component.supportClasses.map((c) => c.define()).toList().join('\n')}

${customBlock(id.snake)}
''';
      var dartFile = "${componentPath}/${component.id.snake}.dart";
      mergeWithFile(definition, dartFile);

    });

    var cssFile = "${rootPath}/${id.snake}/lib/components/${id.snake}.css";
    List<String> cssEntries = [];
    cssEntries.add(cssCustomBlock('${id} top'));

    components.forEach((component) {
      cssEntries.add('''
[is=${component.id.emacs}] {
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
          '<link rel="import" href="../packages/${id.snake}/components/${component.id.snake}.html">').toList();
    importStatements.add('<link rel="stylesheet" href="../packages/${id.snake}/components/${id.snake}.css">');

    examples.forEach((example) {
      var exampleHtmlFile = "${rootPath}/${id.snake}/example/${example.id.snake}/${example.id.snake}.html";
      var exampleHtml = '''<!DOCTYPE html>
<html>
  <head>
${indentBlock(importStatements.join('\n'))}  
${indentBlock('<script src="packages/polymer/boot.js"></script>')}
${indentBlock(htmlCustomBlock('head ${example.id}'))}
  </head>
  <body>
${indentBlock(htmlCustomBlock('body ${example.id}'))}
${indentBlock('<script type="application/dart"> main(){} </script>')}
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
  /// Prefix associated with component
  String prefix;
  Id _prefixedId;
  /// Id with prefix
  Id get prefixedId => _prefixedId;
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
  /// Name as used in the html (i.e. words of name hyphenated)
  String get name => _name;
  String _prefixedName;
  /// Name including prefix
  String get prefixedName => _prefixedName;
  bool _finalized = false;
  /// Set to true on finalize
  bool get finalized => _finalized;

// custom <class Component>

  void finalize() {
    if(!_finalized) {
      _name = id.emacs;
      _prefixedId = (prefix != null)? new Id('${prefix}_${id.snake}') : id;
      _prefixedName = _prefixedId.emacs;
      if(implClass == null) {
        print("Creating impl of type ${id}");
        implClass = new Class(id)
          ..extend = 'PolymerElement'
          ..doc = doc;
      }

      // Reuse component doc for implClass
      if(implClass.doc == null) implClass.doc = doc;
      // Ensure implClass is derived from WebComponent (for now)
      if(implClass.extend == null) implClass.extend = 'PolymerElement';

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
    <polymer-element name="${prefixedName}" extends="${new Id(extendsElement).emacs}" constructor="${id.capCamel}" apply-author-styles>
      <template>
${indentBlock(templateFragment, '        ')}
${indentBlock(htmlCustomBlock('${id} template'), '        ')}
      </template>
      <script type="application/dart" src="${id.snake}.dart"></script>
    </polymer-element>
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

