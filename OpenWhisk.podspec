Pod::Spec.new do |s|

	s.name         = 'OpenWhisk'
	s.version      = '0.1.6'
	s.summary      = 'Mobile SDK to use OpenWhisk server-less environment'
	s.homepage     = 'http://www.ibm.com/mobilefirst/us/en/'
	s.license      = { :type => 'Apache License, Version 2.0' }
	s.authors      = 'IBM'

	s.description  = <<-DESC
	OpenWhisk is a cloud-first distributed event-based programming service. OpenWhisk provides a programming model to upload event handlers to a cloud service, and register the handlers to respond to various events.

	It's cool.
	DESC

	s.platform = :ios, '9.0'
	s.frameworks = 'Foundation', 'WatchConnectivity'

	s.source       = { :git => 'https://github.com/openwhisk/openwhisk-client-swift.git', :tag => "#{s.version}" }

	s.source_files  = 'OpenWhisk/*.{swift,h}'
	s.resource_bundles = {'OpenWhiskResources' =>  ['OpenWhisk/OpenWhiskConfig.plist']}

end
