Pod::Spec.new do |s|
  s.name             = 'JLDatabase'
  s.version          = '0.1.0'
  s.summary          = 'JLDatabase base on FMDB'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
JLDatabase base on FMDB, use FMDB is easy.
                       DESC

  s.homepage         = 'https://github.com/lzkkk/JLDatabase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lzkkk' => 'jlgoodlucky@gmail.com' }
  s.source           = { :git => 'https://github.com/lzkkk/JLDatabase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JLDatabase/Classes/*.{h,m}'

  s.requires_arc = true

  s.dependency "FMDB"
end

