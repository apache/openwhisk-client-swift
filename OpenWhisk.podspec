Pod::Spec.new do |s|

	s.name         = 'OpenWhisk'
	s.version      = '0.3.0'
	s.summary      = 'Apache OpenWhisk Client SDK'
	s.homepage     = 'https://apache.openwhisk.org'
	s.license      = { :type => 'Apache License, Version 2.0' }
	s.authors      = 'Apache OpenWhisk'

	s.description  = <<-DESC
	OpenWhisk is a cloud-first distributed event-based programming service. OpenWhisk provides a programming model to upload event handlers to a cloud service, and register the handlers to respond to various events.

	DESC

	s.ios.deployment_target = '11.0'
	s.watchos.deployment_target = '4.0'

	s.source       = { :git => 'https://github.com/apache/incubator-openwhisk-client-swift.git', :tag => "#{s.version}" }


	s.source_files  = 'OpenWhisk/*.{swift,h}'
	s.watchos.exclude_files = 'OpenWhisk/OpenWhiskButton.swift'

	s.frameworks = 'Foundation', 'WatchConnectivity'
	s.resource_bundles = {'OpenWhiskResources' =>  ['OpenWhisk/OpenWhiskConfig.plist']}

end
