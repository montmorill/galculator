project(
  'Galculator',
  'vala',
  default_options: ['warning_level=0'],
)

add_project_arguments('-Wno-discarded-qualifiers', language: 'c')

gtk4_dep = dependency('gtk4', version: '>=4.0')

subdir('src')