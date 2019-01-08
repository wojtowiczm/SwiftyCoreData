
Pod::Spec.new do |s|

  s.name         = "SwiftyCoreData"
  s.version      = "0.0.2"
  s.summary      = "Lightweight wrapper for old fashioned CoreData framework"
  s.description  = "TBD"
  
  s.swift_version = "4.2"

  s.homepage     = "https://github.com/wojtowiczm"

  s.license      = "MIT "
  s.author       = { "Michał Wójtowicz" => "wojtowiczmichal97@gmail.com" }
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/wojtowiczm/SwiftyCoreData.git", :tag => "#{s.version}" }


  s.source_files  = "SwiftyCoreData/**/*.swift"



end
