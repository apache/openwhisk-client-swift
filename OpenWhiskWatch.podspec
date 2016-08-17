Pod::Spec.new do |s|

	s.name         = 'OpenWhiskWatch'
	s.version      = '0.1.6'
	s.summary      = 'Mobile SDK to use OpenWhisk serverless environment from WatchOS2'
	s.homepage     = 'http://www.ibm.com/mobilefirst/us/en/'
	s.license      = { :type => 'Apache License, Version 2.0' }
	s.authors      = 'IBM'

	s.description  = <<-DESC
	OpenWhisk is a cloud-first distributed event-based programming service. OpenWhisk provides a programming model to upload event handlers to a cloud service, and register the handlers to respond to various events.

	DESC

	s.platform     = :watchos, '2.0'
	s.frameworks = 'Foundation', 'WatchConnectivity'

	s.author       = { 'Paul Castro' => 'castrop@us.ibm.com' }
	s.source       = { :git => 'https://github.com/openwhisk/openwhisk-client-swift.git', :tag => "#{s.version}" }

	s.source_files  = 'OpenWhisk/*.{swift,h}'
	s.exclude_files = 'OpenWhisk/OpenWhiskButton.swift'
	s.resource_bundles = {'OpenWhiskWatchResources' => ['OpenWhisk/OpenWhiskConfig.plist']}

end
