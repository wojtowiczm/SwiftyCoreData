
Pod::Spec.new do |s|

  s.name         = "SwiftyCoreData"
  s.version      = "0.0.1"
  s.summary      = "A short description of [SwiftyCoreData."
  s.description  = "Lightweight wrapper for old fashioned CoreData framework"

  s.homepage     = "https://github.com/wojtowiczm"

  s.license      = "MIT "
  s.author       = { "Michał Wójtowicz" => "wojtowiczmichal97@gmail.com" }
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/wojtowiczm/SwiftyCoreData.git", :tag => "#{s.version}" }


  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"


end
