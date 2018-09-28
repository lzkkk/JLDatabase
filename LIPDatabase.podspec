Pod::Spec.new do |s|
  s.name             = 'LIPDatabase'
  s.version          = '0.1.0'
  s.summary          = 'lipDatabase based on FMDB.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  LIPDatabase 
                       DESC

  s.homepage         = 'https://github.com/lzkkk/LIPDatabase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lzkkk' => '475586149@qq.com' }
  s.source           = { :git => 'https://github.com/lzkkk/LIPDatabase.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LIPDatabase/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LIPDatabase' => ['LIPDatabase/Assets/*.png']
  # }

  s.requires_arc = true

  s.dependency "FMDB"

end
