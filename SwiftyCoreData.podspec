
Pod::Spec.new do |s|

  s.name         = "SwiftyCoreData"
  s.version      = "0.2.0"
  s.summary      = "Lightweight wrapper for old fashioned CoreData framework"
  s.description  = "SwiftyCoreData is a lightweight libliary written in Swift. General purpose is to make using CoreData easier without unnecessary template code"
  
  s.swift_version = "4.2"

  s.homepage     = "https://github.com/wojtowiczm"

  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author       = { "Michał Wójtowicz" => "wojtowiczmichal97@gmail.com" }
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/wojtowiczm/SwiftyCoreData.git", :tag => "#{s.version}" }


  s.source_files  = "SwiftyCoreData/**/*.swift"



end
