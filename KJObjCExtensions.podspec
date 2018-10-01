Pod::Spec.new do |s|
  s.name     = 'KJObjCExtensions'
  s.version  = '0.0.1'
  s.platform = :ios, '5.0'
  s.license  = 'MIT'
  s.summary  = 'Extensions'
  s.homepage = 'https://github.com/kevjett/KJObjCExtensions'
  s.author   = { 'Kevjett' => 'kevjett@gmail.com' }
  s.source   = { :git => 'https://github.com/kevjett/KJObjCExtensions.git', :tag => s.version.to_s }
  s.frameworks   = 'Security'
  s.source_files = 'KJObjCExtensions/**/*.{h,m}'
  s.requires_arc = true
end