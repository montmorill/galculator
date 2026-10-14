config_vala_file = configure_file(
  input: 'config.vala.in',  
  output: 'config.vala',    
  configuration: configuration_data({
    'VERSION': meson.project_version(),
    'GETTEXT_PACKAGE': meson.project_name(),
  })
)

executable(
  'galculator',
  'Galculator.vala',
  config_vala_file,
  dependencies: [gtk4_dep],
  install: true,
)