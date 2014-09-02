Pod::Spec.new do |s|
  s.name		= "IdentityMapper"
  s.version		= "0.0.2"
  s.source		= { :git => "https://github.com/pjechris/IdentityMapper.git",
  		     	    :tag => s.version.to_s }

  s.summary          	= "Ensure each object from WS or databse get loaded only once in memory"
  s.description         = "Implementation of the Identity map design pattern. That allow you to ensure consistency by creating
  only one object per WS/database record. No more conflicts nor object update issue!"
  s.homepage            = "https://github.com/pjechris/IdentityMapper"
  s.license		= { :type => "MIT", :file => "LICENSE" }
  s.author              = 'pjechris'

  s.platform		= :ios, "6.0"
  s.source_files    	= 'Src/**/*.{h,m}'
  s.prefix_header_file  = "Src/#{s.name}.h"
  s.requires_arc 	= true

end
