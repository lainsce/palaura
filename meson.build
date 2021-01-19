project('com.github.lainsce.palaura', ['vala', 'c'], version: '2.0.0')
gnome = import('gnome')
i18n = import('i18n')

add_project_arguments([
		'--target-glib=2.40',
	],
	language: 'vala',
)
add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

asresources = gnome.compile_resources(
    'as-resources', 'data/style.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

sources = files(
    'src/Core/Definition.vala',
    'src/Core/DictCore.vala',
    'src/Views/View.vala',
    'src/Views/WordListView.vala',
    'src/Views/SearchView.vala',
    'src/Views/NormalView.vala',
    'src/Views/DefinitionView.vala',
    'src/Widgets/WordListRow.vala',
    'src/Widgets/WordContainerGrid.vala',
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/BookmarkRow.vala',
    'src/RecentsRow.vala',
)

dependencies = [
    dependency('gio-2.0'),
    dependency('gtk+-3.0'),
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gee-0.8'),
    dependency('libhandy-1'),
    dependency('granite'),
    dependency('libhandy-1'),
    dependency('libsoup-2.4'),
    dependency('json-glib-1.0'),
    dependency('gstreamer-1.0'),
    dependency('gtksourceview-3.0'),
]

# Let's define our executable
executable(
    meson.project_name(),
    sources,
    asresources,
    dependencies: dependencies,
    install : true
)

subdir('data')
subdir('po')

meson.add_install_script('meson/post_install.py', join_paths(get_option('prefix'), get_option('datadir')))
