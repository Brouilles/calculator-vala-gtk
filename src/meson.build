calculator_sources = [
  'main.vala',
  'window.vala',
]

calculator_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
]

gnome = import('gnome')

executable('calculator', calculator_sources,
  vala_args: '--target-glib=2.50',  dependencies: calculator_deps,
  install: true,
)
