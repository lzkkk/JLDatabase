

Pod::Spec.new do |s|


  s.name         = "LIPDatabase"
  s.version      = "1.0.1"
  s.summary      = "lipDatabase based on FMDB. author lip"

  s.description  = <<-DESC
                  lipDatabase based on FMDB. and author lip, lip is a boy.
                   DESC

  s.homepage     = "https://github.com/lzkkk/LIPDatabase.git"

  s.license      = "MIT"


  s.author             = { "Lip" => "475586149@qq.com" }
 


  s.platform     = :ios
  s.platform     = :ios, "6.0"

  #  When using multiple platforms
  s.ios.deployment_target = "6.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"



  s.source       = { :git => "https://github.com/lzkkk/LIPDatabase.git", :tag => s.version.to_s }

  s.source_files  = "LIPDatabase/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  s.dependency "FMDB"

end
