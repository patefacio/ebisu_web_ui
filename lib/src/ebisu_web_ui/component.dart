part of ebisu_web_ui.ebisu_web_ui;

/// Example usage of the components
class Example {
  Example(this.id);

  /// Id of the example
  final Id id;
  /// If true includes the standard export of polymer/init.dart otherwise includes dart file
  bool initPolymer = true;
  /// Top part in body allowing code generated custom content
  String neck;
  /// Bottom part in body allowing code generated custom content
  String feet;
  ComponentFilter importComponentsWhere;
// custom <class Example>

  String get relativePath =>
    'web/examples/${id.snake}/${id.snake}.html';

// end <class Example>
}

/// Create a Example sans new, for more declarative construction
Example
example([Id id]) =>
  new Example(id);

/// Collection of components wrapped in a library (think http://pub.dartlang.org/packages/widget)
class ComponentLibrary {
  ComponentLibrary(this.id) {
    // custom <ComponentLibrary>

    pubSpec = new PubSpec(id)
      ..addDependency(pubdep('polymer')..version = ">=0.15.0")
      ..addDependency(new PubDependency('logging'))
      ..pubTransformers = [  ]
      ;

    system = new System(id)
      ..pubSpec = pubSpec;

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
  /// System containing this single component library
  System system;
  /// Pubspec for this component library
  PubSpec pubSpec;
  /// List of support libraries
  List<Library> libraries = [];
  /// List of components in the collection
  List<Component> components = [];
  /// Set to true on finalize
  bool get finalized => _finalized;
  /// List of PubDependency for this component and supporting libraries
  List<PubDependency> dependencies = [];
  /// List of examples for the component library
  List<Example> examples = [];
// custom <class ComponentLibrary>

  toString() => '''ComponentLibrary(${id.emacs}) [
\t${components.map((c)=>c.toString()).join('\n\t')}
]''';

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

  generateExamples() {
    // For example codegen - import all components

    examples.forEach((example) {

      var componentsToImport = (example.importComponentsWhere != null)?
        components.where(example.importComponentsWhere) : components;

      List<String> importStatements =
        componentsToImport.map((component) =>
            '<link rel="import" href="packages/${id.snake}/components/${component.id.snake}.html">').toList();

      importStatements.add('<link rel="stylesheet" href="packages/${id.snake}/components/${id.snake}.css">');

      var exampleHtmlFile = "${rootPath}/${id.snake}/web/examples/${example.id.snake}/${example.id.snake}.html";
      var neck = example.neck != null? example.neck : '';
      var feet = example.feet != null? example.feet : '';
      var initCode = example.initPolymer?
        '''
<script type="application/dart">
    import 'package:polymer/polymer.dart';
    import 'package:logging/logging.dart';

    main() {
      Logger.root.onRecord.listen((LogRecord r) =>
        print("\${r.loggerName} [\${r.level}]:\\t\${r.message}"));
      Logger.root.level = Level.FINEST;
      initPolymer();
    }
</script>
'''
:'';
      var scriptImport = example.initPolymer?
        '' : '<script type="application/dart" src="${example.id.snake}.dart"></script>';
      var exampleHtml = '''<!DOCTYPE html>
<html>
  <head>
    <title>${example.id} example showing usage of ${id} component library</title>
${chomp(indentBlock(htmlCustomBlock('forehead ${example.id}'), '    '))}
    <script src="packages/web_components/platform.js"></script>
${indentBlock(importStatements.join('\n'), '    ')}
${chomp(indentBlock(htmlCustomBlock('additional polymer imports ${example.id}'), '    '))}

    <style>
${chomp(indentBlock(cssCustomBlock('style ${example.id}'), '      '))}
    </style>

${chomp(indentBlock(htmlCustomBlock('chin ${example.id}'), '    '))}
    $scriptImport
  </head>
  <body unresolved>
$neck${chomp(indentBlock(htmlCustomBlock('body ${example.id}'), '    '))}$feet
  $initCode
  </body>
</html>
''';

      mergeBlocksWithFile(exampleHtml, exampleHtmlFile, [
        [ htmlCustomBegin, htmlCustomEnd ],
        [ cssCustomBegin, cssCustomEnd ]
      ]);

      if(!example.initPolymer) {
        var exampleDartFile = "${rootPath}/${id.snake}/web/examples/${example.id.snake}/${example.id.snake}.dart";
        mergeBlocksWithFile('''
import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
${customBlock('additional imports')}

main() {
  Logger.root.onRecord.listen((LogRecord r) =>
    print("\${r.loggerName} [\${r.level}]:\\t\${r.message}"));
  Logger.root.level = Level.FINEST;
  initPolymer().run(() {
    Polymer.onReady.then((var _) {
${customBlock('${example.id} main')}
    });
  });
}

${customBlock('additional code')}
''', exampleDartFile);
      }


    });
  }

  generate() {
    finalize();
    var componentPath = "${rootPath}/${id.snake}/lib/components";
    var cssFile = "$componentPath/${id.snake}.css";

    List<String> cssEntries = [];
    cssEntries.add(cssCustomBlock('${id} top'));

    components.forEach((component) {
      var name = component.id.capCamel;
      component.generateDartImpl(componentPath);
      if(!component.nonPolymer) {
        component.generateHtml(componentPath);
        cssEntries.add('''
${component.prefixedName} {
${indentBlock(cssCustomBlock(component.id.emacs))}
}
''');
      }
    });

    cssEntries.add(cssCustomBlock('${id} bottom'));
    cssMergeWithFile(cssEntries.join('\n\n'), cssFile);

    pubSpec.addDependencies(dependencies);
    if(pubSpec.doc == null)
      pubSpec.doc = doc;

    if(system.rootPath == null)
      system.rootPath = "${rootPath}/${id.snake}";

    system.libraries = libraries;
    if(examples.length > 0) {
      final entryPoints = [];
      examples.forEach((Example example) {
        entryPoints.add(example.relativePath);
      });
      pubSpec.addTransformer(new PolymerTransformer(entryPoints));
    }
    system.generate();
    generateExamples();
  }

// end <class ComponentLibrary>
  bool _finalized = false;
}

/// Declaratively define component to generate its stubbed out support
class Component {
  Component(this.id);

  /// Id - used to generate name of component
  Id id;
  /// Description of the component
  String doc;
  /// Prefix associated with component
  String prefix;
  /// Id with prefix
  Id get prefixedId => _prefixedId;
  /// Dom element or other component being extended
  String extendsElement;
  /// Class implementing this component - currently will extend WebComponent
  Class implClass;
  /// Enums defined in this component
  List<Enum> enums = [];
  /// Any additional support classes required to implement this component
  List<Class> supportClasses = [];
  /// How to construct the component (convention handles unless exceptional case)
  String constructor;
  /// If true styles from document apply to control
  bool applyAuthorStyles = true;
  /// If extends with observable
  bool observable = false;
  /// The internals of template fragment that will be rendered when the component is initialized
  String templateFragment = '';
  /// Dart imports required by the component
  List<String> imports = [];
  /// Component imports required by the component
  List<String> htmlImports = [];
  /// Name as used in the html (i.e. words of name hyphenated)
  String get name => _name;
  /// Name including prefix
  String get prefixedName => _prefixedName;
  /// If true just make a non-polymer dart library
  bool nonPolymer = false;
  /// Set to true on finalize
  bool get finalized => _finalized;
// custom <class Component>

  toString() => 'Component($prefixedName)';

  void finalize() {
    if(!_finalized) {
      _name = id.emacs;
      _prefixedId = (prefix != null)? new Id('${prefix}_${id.snake}') : id;
      _prefixedName = _prefixedId.emacs;

      if(implClass == null) {
        implClass = new Class(id);
      }

      implClass.doc = doc;

      if(!nonPolymer) {
        var polymerCreated =
          (null != extendsElement)? "  polymerCreated();\n" : "";

        implClass
          ..extend = implClass.extend == null? extendClause : implClass.extend
          ..members.addAll([
            member('is_attached')..classInit = false..access = IA,
            member('on_attached_handlers')..classInit = []..access = IA,
          ])
          ..topInjection = '''

${id.capCamel}.created() : super.created() {
  _logger.fine('${id.capCamel} created sr => \$shadowRoot');
${polymerCreated}${indentBlock(customBlock('${id.capCamel} created'))}
}

@override
void domReady() {
  super.domReady();
  _logger.fine('${id.capCamel} domReady with sr => \$shadowRoot');
${polymerCreated}${indentBlock(customBlock('${id.capCamel} domReady'))}
}

@override
void ready() {
  super.ready();
  _logger.fine('${id.capCamel} ready with sr => \$shadowRoot');
${polymerCreated}${indentBlock(customBlock('${id.capCamel} ready'))}
}

@override
void attached() {
${polymerCreated}${indentBlock(customBlock('${id.capCamel} pre-attached'))}
  super.attached();
  _logger.fine('${id.capCamel} attached with sr => \$shadowRoot');
  assert(shadowRoot != null);
${polymerCreated}${indentBlock(customBlock('${id.capCamel} attached'))}
  _isAttached = true;
  _onAttachedHandlers.forEach((handler) => handler(this));
}

void onAttached(void onAttachedHandler(${id.capCamel})) {
  if(_isAttached) {
    onAttachedHandler(this);
  } else {
    _onAttachedHandlers.add(onAttachedHandler);
  }
}
''';
      }

      // Reuse component doc for implClass
      if(implClass.doc == null) implClass.doc = doc;
      supportClasses.forEach((c) => (c.parent = null));
      enums.forEach((e) => (e.parent = null));
      _finalized = true;
    }
  }

  String get extendClause {
    String result = '';
    if(null != extendsElement) {
      if(elementMapping.containsKey(extendsElement)) {
        result = elementMapping[extendsElement];
      } else {
        result = idFromString(extendsElement).capCamel;
      }
      result += " with Polymer";
      if(observable) {
        result += ", Observable";
      }
    } else {
      return "PolymerElement";
    }
    return result;
  }

  String get extendsHtmlClause =>
    (null != extendsElement) ? ' extends = "${extendsElement}"' : '';

  generateDartImpl(String componentPath) {
    var requiredImports = [
      "'dart:html' hide Timeline",
      'package:logging/logging.dart' ];
    String customTag = '';
    if(!nonPolymer) {
      requiredImports.add('package:polymer/polymer.dart');
      customTag = '@CustomTag("${prefixedName}")\n';
    }
    requiredImports.addAll(imports);

    var definition = '''
library ${id.snake};
${cleanImports(requiredImports
   .map((comp) => Library.importStatement(comp)).toList()).join('\n')}

${customBlock('additional imports')}

final _logger = new Logger("${id}");

$customTag${implClass.define()}
${enums.map((e) => e.define()).toList().join('\n')}
${supportClasses.map((c) => c.define()).toList().join('\n')}

${chomp(customBlock(id.snake))}
''';
    var dartFile = "${componentPath}/${id.snake}.dart";
    mergeWithFile(definition, dartFile);
  }

  generateHtml(String componentPath) {
    var htmlFile = "${componentPath}/${id.snake}.html";
    mergeBlocksWithFile(html, htmlFile, [
      [ htmlCustomBegin, htmlCustomEnd ],
      [ cssCustomBegin, cssCustomEnd ]
    ]);
  }

  String get html {
    String htmlImportsBlock = indentBlock(htmlImports.map((i) =>
            '<link rel="import" href=${importUri(i)}>').toList().join('\n'));

    return '''<!DOCTYPE html>
<link rel="import" href="../../../packages/polymer/polymer.html">

${htmlImportsBlock}
${htmlCustomBlock('${id} head')}

<polymer-element name="${prefixedName}"${extendsHtmlClause}>
  <template>
    <style>
${chomp(indentBlock(cssCustomBlock('${id} style'), '    '))}
    </style>
${indentBlock(templateFragment, '    ')}
${indentBlock(htmlCustomBlock('${id} template'), '    ')}
  </template>
  <script type="application/dart" src="${id.snake}.dart"></script>
</polymer-element>
''';
  }

// end <class Component>
  Id _prefixedId;
  String _name;
  String _prefixedName;
  bool _finalized = false;
}

class LabeledElement {
  Id id;
  String label;
  String elementComponentName;
  // custom <class LabeledElement>
  LabeledElement(this.id, this.label, this.elementComponentName);
  // end <class LabeledElement>
}

/// Declaratively define a form component
class FormComponent extends Component {
  String legendText;
  List labeledElements = [];
  // custom <class FormComponent>

  FormComponent(Id _id) : super(_id) { print("Created form ${id}");}

  get fields => labeledElements.map((le) => '''

      <label>${le.label}</label>
      <${le.elementComponentName} id="${le.id.emacs}"></${le.elementComponentName}>
                                    ''').join();

  String get html {
    String htmlImportsBlock = indentBlock(htmlImports.map((i) =>
            '<link rel="import" href=${importUri(i)}>').toList().join('\n'));
    var id = this.id;
    var legend = legendText != null? '<legend>$legendText</legend>' : '';
    return '''<!DOCTYPE html>
${htmlImportsBlock}
${htmlCustomBlock('${id} head')}
<link rel="import" href="../../../packages/polymer/polymer.html">
<polymer-element name="${prefixedName}"${extendsHtmlClause}>
  <template>
    <style>
${chomp(indentBlock(cssCustomBlock('${id} style'), '    '))}
    </style>
    <fieldset>
      ${legend}
      ${fields}
${indentBlock(templateFragment, '    ')}
${indentBlock(htmlCustomBlock('${id} template'), '    ')}
    </fieldset>
  </template>
  <script type="application/dart" src="${this.id.snake}.dart"></script>
</polymer-element>
''';
  }

  // end <class FormComponent>
}

/// Details for an individual entry in a picklist
class PicklistEntry {
  Id id;
  String label;
  String toolTip;
  // custom <class PicklistEntry>
  // end <class PicklistEntry>
}

/// Declaratively define a pick list
class PicklistComponent extends Component {
  List<PickListEntry> entries = [];
  // custom <class PicklistComponent>

  PicklistComponent(Id _id) : super(_id) { /*print("Created picklist ${id}");*/ }

  String get html {
    String htmlImportsBlock = indentBlock(htmlImports.map((i) =>
            '<link rel="import" href=${importUri(i)}>').toList().join('\n'));
    var id = this.id;
    return '''<!DOCTYPE html>
${htmlImportsBlock}
${htmlCustomBlock('${id} head')}
<link rel="import" href="../../../packages/polymer/polymer.html">
<polymer-element name="${prefixedName}"${extendsHtmlClause}>
  <template>
    <style>
${chomp(indentBlock(cssCustomBlock('${id} style'), '    '))}
    </style>
    <select>
${entries.map((e) => '      <option value="${e.id.snake}">${e.label}</option>').join('\n')}
    </select>
  </template>
  <script type="application/dart" src="${this.id.snake}.dart"></script>
</polymer-element>
''';
  }

  // end <class PicklistComponent>
}
// custom <part component>

ComponentLibrary componentLibrary(String _id) => new ComponentLibrary(id(_id));
Component component(String _id) => new Component(id(_id));
FormComponent formComponent(String _id) => new FormComponent(id(_id));

typedef List ComponentFilter(Component component);

// end <part component>

Map elementMapping = {
  'html' : 'HtmlElement',
   //'' : 'SvgElement',
  'a' : 'AnchorElement',
   //'' : 'AudioElement',
  'button' : 'ButtonElement',
   //  '' : 'CanvasElement',
  'div' : 'DivElement',
  'img' : 'ImageElement',
  'input' : 'InputElement',
  'li' : 'LIElement',
  'label' : 'LabelElement',
  'menu' : 'MenuElement',
  'meter' : 'MeterElement',
  'ol' : 'OListElement',
  'option' : 'OptionElement',
  'output' : 'OutputElement',
  'p' : 'ParagraphElement',
  'pre' : 'PreElement',
  'progress' : 'ProgressElement',
  'select' : 'SelectElement',
  'span' : 'SpanElement',
  'ul' : 'UListElement',
  'video' : 'VideoElement',
};
