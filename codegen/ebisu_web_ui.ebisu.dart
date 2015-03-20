import "dart:io";
import "package:path/path.dart" as path;
import "package:ebisu/ebisu.dart";
import "package:id/id.dart";
import "package:ebisu/ebisu_dart_meta.dart";

String _topDir = path.dirname(path.dirname(path.absolute(Platform.script.path)));

main() {

  System ebisu_web_ui = system('ebisu_web_ui')
    ..rootPath = _topDir
    ..pubSpec = (pubspec('ebisu_web_ui')
        ..dependencies = [
        ]
    )
    ..includesReadme = true
    ..includesHop = true
    ..scripts = [
    ]
    ..libraries = [
      library('ebisu_web_ui')
      ..doc = 'Support for generating shell for web components per http://www.dartlang.org/articles/web-ui/spec.html'
      ..imports = [
        '"package:ebisu/ebisu.dart"',
        '"package:id/id.dart"',
        '"package:ebisu/ebisu_dart_meta.dart"',
      ]
      ..parts = [
        part('component')
        ..doc = 'Support for stubbing out components'
        ..variables = [
          variable('element_mapping')
          ..type = 'Map'
          ..init = '''{
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
}'''
        ]
        ..classes = [
          class_('example')
          ..doc = 'Example usage of the components'
          ..hasCtorSansNew = true
          ..members = [
            member('id')
            ..doc = 'Id of the example'
            ..type = 'Id'
            ..isFinal = true
            ..ctors = [''],
            member('init_polymer')
            ..doc = 'If true includes the standard export of polymer/init.dart otherwise includes dart file'
            ..type = 'bool'
            ..classInit = 'true',
            member('neck')
            ..doc = 'Top part in body allowing code generated custom content',
            member('feet')
            ..doc = 'Bottom part in body allowing code generated custom content',
            member('import_components_where')..type = 'ComponentFilter',
          ],
          class_('component_library')
          ..doc = 'Collection of components wrapped in a library (think http://pub.dartlang.org/packages/widget)'
          ..ctorCustoms = ['']
          ..members = [
            member('doc')
            ..doc = 'Documentation for the component library',
            member('prefix')
            ..doc = 'Prefix associated with all components in the library',
            member('root_path')
            ..doc = 'Path in which to generate the component library',
            member('is_inlined')
            ..doc = 'If true generates entire component library as single file'
            ..type = 'bool'
            ..classInit = 'false',
            member('default_member_access')
            ..doc = 'Default access for members'
            ..type = 'Access'
            ..classInit = 'Access.IA',
            member('id')
            ..doc = 'Id of the component library'
            ..type = 'Id'
            ..isFinal = true
            ..ctors = [''],
            member('system')
            ..doc = 'System containing this single component library'
            ..type = 'System',
            member('pub_spec')
            ..doc = 'Pubspec for this component library'
            ..type = 'PubSpec',
            member('libraries')
            ..doc = 'List of support libraries'
            ..type = 'List<Library>'
            ..classInit = '[]',
            member('components')
            ..doc = 'List of components in the collection'
            ..type = 'List<Component>'
            ..classInit = '[]',
            member('finalized')
            ..doc = 'Set to true on finalize'
            ..access = Access.RO
            ..type = 'bool'
            ..classInit = 'false',
            member('dependencies')
            ..doc = 'List of PubDependency for this component and supporting libraries'
            ..type = 'List<PubDependency>'
            ..classInit = '[]',
            member('examples')
            ..doc = 'List of examples for the component library'
            ..type = 'List<Example>'
            ..classInit = '[]',
          ],
          class_('component')
          ..doc = 'Declaratively define component to generate its stubbed out support'
          ..members = [
            member('id')
            ..doc = 'Id - used to generate name of component'
            ..type = 'Id'
            ..ctors = [''],
            member('doc')
            ..doc = 'Description of the component',
            member('prefix')
            ..doc = 'Prefix associated with component',
            member('prefixed_id')
            ..type = 'Id'
            ..access = Access.RO
            ..doc = 'Id with prefix',
            member('extends_element')
            ..doc = 'Dom element or other component being extended',
            member('impl_class')
            ..doc = 'Class implementing this component - currently will extend WebComponent'
            ..type = 'Class',
            member('enums')
            ..doc = 'Enums defined in this component'
            ..type = 'List<Enum>'
            ..classInit = '[]',
            member('support_classes')
            ..doc = 'Any additional support classes required to implement this component'
            ..type = 'List<Class>'
            ..classInit = '[]',
            member('constructor')
            ..doc = 'How to construct the component (convention handles unless exceptional case)',
            member('apply_author_styles')
            ..doc = 'If true styles from document apply to control'
            ..type = 'bool'
            ..classInit = 'true',
            member('observable')
            ..doc = 'If extends with observable'
            ..type = 'bool'
            ..classInit = 'false',
            member('template_fragment')
            ..doc = 'The internals of template fragment that will be rendered when the component is initialized'
            ..classInit = '',
            member('imports')
            ..doc = 'Dart imports required by the component'
            ..type = 'List<String>'
            ..classInit = '[]',
            member('html_imports')
            ..doc = 'Component imports required by the component'
            ..type = 'List<String>'
            ..classInit = '[]',
            member('name')
            ..doc = 'Name as used in the html (i.e. words of name hyphenated)'
            ..access = Access.RO,
            member('prefixed_name')
            ..access = Access.RO
            ..doc = 'Name including prefix',
            member('non_polymer')
            ..doc = 'If true just make a non-polymer dart library'
            ..type = 'bool'
            ..classInit = 'false',
            member('finalized')
            ..doc = 'Set to true on finalize'
            ..access = Access.RO
            ..type = 'bool'
            ..classInit = 'false',
          ],
          class_('labeled_element')
          ..members = [
            member('id')..type = 'Id',
            member('label'),
            member('element_component_name'),
          ],
          class_('form_component')
          ..doc = 'Declaratively define a form component'
          ..extend = 'Component'
          ..members = [
            member('legend_text'),
            member('labeled_elements')..classInit = []
          ],
          class_('picklist_entry')
          ..doc = 'Details for an individual entry in a picklist'
          ..members = [
            member('id')..type = 'Id',
            member('label'),
            member('tool_tip'),
          ],
          class_('picklist_component')
          ..doc = 'Declaratively define a pick list'
          ..extend = 'Component'
          ..members = [
            member('entries')..type = 'List<PickListEntry>'..classInit = [],
          ]
        ]
      ]

    ];

  ebisu_web_ui.generate();
}
