/*
 * Copyright 2015-2016 IBM Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
import OpenWhisk

class NetworkUtilsDelegate: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }

}

class OpenWhiskTests: XCTestCase {
    
    let Timeout:TimeInterval = 100 // time to wait for whisk action to complete
    
    var apiKey: String?
    var apiSecret: String?
    
    override func setUp() {
        super.setUp()
        
        
        if let config = Config.getAuthToken() {
            apiKey = config.apiKey
            apiSecret = config.apiSecret
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    func testWhiskParameterizedAction() {
        
        if let apiKey = apiKey, let apiSecret = apiSecret {
            // allow for self-signed certificates
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: NetworkUtilsDelegate(), delegateQueue:OperationQueue.main)
            
            let credentials = WhiskCredentials(accessKey: apiKey, accessToken: apiSecret)
            let whisk = Whisk(credentials: credentials)
            whisk.urlSession = session
            
            // setup for async testing
            let expectation = self.expectation(description: "Whisk Callback")
            
            do {
                try whisk.invokeAction(name: "date", package: "util", namespace: "whisk.system", parameters: nil, hasResult: true,
                                       callback: {(reply, error) in
                                        
                                        if let error = error {
                                            if case let WhiskError.httpError(description, statusCode) = error {
                                                
                                                print("Error: \(description) statusCode: \(statusCode))")
                                                
                                                if statusCode != 401 && statusCode != 404 && statusCode != 408 && statusCode != 500 {
                                                    XCTFail("Error: \(description) statusCode: \(statusCode))")
                                                }
                                                
                                            }
                                        }
                                        
                                        if let reply = reply {
                                            
                                            print("Reply is \(reply)")
                                            XCTAssertNotNil(reply["activationId"])
                                            let id = reply["activationId"] as! String
                                            print("Got id \(id)")
                                        }
                                        
                                        expectation.fulfill()
                                        
                                        
                })
            } catch {
                print(error)
                XCTFail("Error invoking action \(error)")
            }
            
            waitForExpectations(timeout: Timeout, handler: { error in
                
                if let error = error {
                    print("Error: \(error)")
                }
            })
        } else {
            XCTFail("No credentials available to run test")
        }
    }
    
    func testWhiskQualifiedNameAction() {
        
        if let apiKey = apiKey, let apiSecret = apiSecret {
            // setup for async testing
            let expectation = self.expectation(description: "Whisk Callback")
            // allow for self-signed certificates
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: NetworkUtilsDelegate(), delegateQueue:OperationQueue.main)
            
            let credentials = WhiskCredentials(accessKey: apiKey, accessToken: apiSecret)
            let whisk = Whisk(credentials: credentials)
            whisk.urlSession = session
            do {
                try whisk.invokeAction(qualifiedName: "/whisk.system/util/date", parameters: nil, hasResult: true, callback: {(reply, error) in
                    
                    if let error = error {
                        if case let WhiskError.httpError(description, statusCode) = error {
                            
                            print("Error: \(description) statusCode: \(statusCode))")
                            
                            if statusCode != 401 && statusCode != 404 && statusCode != 408 && statusCode != 500 {
                                XCTFail("Error: \(description) statusCode: \(statusCode))")
                            }
                            
                        }
                    }
                    
                    if let reply = reply {
                        
                        print("Reply is \(reply)")
                        XCTAssertNotNil(reply["activationId"])
                        let id = reply["activationId"] as! String
                        print("Got id \(id)")
                    }
                    
                    expectation.fulfill()
                    
                    
                })
            } catch {
                print(error)
                XCTFail("Error invoking action \(error)")
            }
            
            waitForExpectations(timeout: Timeout, handler: { error in
                
                if let error = error {
                    print("Error: \(error)")
                }
            })
        } else {
            XCTFail("No credentials available to run test")
        }
    }
    
    func testWhiskSettingBaseUrl() {
        
        if let apiKey = apiKey, let apiSecret = apiSecret {
            // setup for async testing
            let expectation = self.expectation(description: "Whisk Callback")
            
            // allow for self-signed certificates
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: NetworkUtilsDelegate(), delegateQueue:OperationQueue.main)
            
            let credentials = WhiskCredentials(accessKey: apiKey, accessToken: apiSecret)
            let whisk = Whisk(credentials: credentials)
            whisk.urlSession = session
            
            do {
                whisk.baseURL = "https://openwhisk.ng.bluemix.net"
                
                try whisk.invokeAction(qualifiedName: "/whisk.system/util/date", parameters: nil, hasResult: true, callback: {(reply, error) in
                    
                    if let error = error {
                        if case let WhiskError.httpError(description, statusCode) = error {
                            
                            print("Error: \(description) statusCode: \(statusCode))")
                            
                            if statusCode != 401 && statusCode != 404 && statusCode != 408 && statusCode != 500 {
                                XCTFail("Error: \(description) statusCode: \(statusCode))")
                            }
                            
                        }
                    }
                    
                    if let reply = reply {
                        
                        print("Reply is \(reply)")
                        XCTAssertNotNil(reply["activationId"])
                        let id = reply["activationId"] as! String
                        print("Got id \(id)")
                    }
                    
                    expectation.fulfill()
                    
                    
                })
            } catch {
                print(error)
                XCTFail("Error invoking action \(error)")
            }
            
            waitForExpectations(timeout: Timeout, handler: { error in
                
                if let error = error {
                    print("Error: \(error)")
                }
            })
            
        } else {
            XCTFail("No credentials available to run test")
        }
    }
    
    func testWhiskVerboseReplies() {
        
        if let apiKey = apiKey, let apiSecret = apiSecret {
            // setup for async testing
            let expectation = self.expectation(description: "Whisk Callback")
            
            // allow for self-signed certificates
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: NetworkUtilsDelegate(), delegateQueue:OperationQueue.main)
            
            let credentials = WhiskCredentials(accessKey: apiKey, accessToken: apiSecret)
            let whisk = Whisk(credentials: credentials)
            whisk.urlSession = session
            whisk.baseURL = "https://openwhisk.ng.bluemix.net"
            
            do {
                whisk.verboseReplies = true
                
                try whisk.invokeAction(qualifiedName: "/whisk.system/util/date", parameters: nil, hasResult: true, callback: {(reply, error) in
                    
                    if let error = error {
                        if case let WhiskError.httpError(description, statusCode) = error {
                            
                            print("Error: \(description) statusCode: \(statusCode))")
                            
                            if statusCode != 401 && statusCode != 404 && statusCode != 408 && statusCode != 500 {
                                XCTFail("Error: \(description) statusCode: \(statusCode))")
                            }
                            
                        }
                    }
                    
                    if let reply = reply {
                        
                        print("Reply is \(reply)")
                        XCTAssertNotNil(reply["activationId"])
                        let id = reply["activationId"] as! String
                        print("Got id \(id)")
                    }
                    
                    expectation.fulfill()
                    
                    
                })
            } catch {
                print(error)
                XCTFail("Error invoking action \(error)")
            }
            
            waitForExpectations(timeout: Timeout, handler: { error in
                
                if let error = error {
                    print("Error: \(error)")
                }
            })
            
        } else {
            XCTFail("No credentials available to run test")
        }
    }
    
    func testWhiskTrigger() {
        
        if let apiKey = apiKey, let apiSecret = apiSecret {
            // setup for async testing
            let expectation = self.expectation(description: "Whisk Callback")
            
            // allow for self-signed certificates
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: NetworkUtilsDelegate(), delegateQueue:OperationQueue.main)
            
            let credentials = WhiskCredentials(accessKey: apiKey, accessToken: apiSecret)
            let whisk = Whisk(credentials: credentials)
            whisk.urlSession = session
            whisk.baseURL = "https://openwhisk.ng.bluemix.net"
            
            do {
                
                try whisk.fireTrigger(name: "myTrigger", callback: { (reply, error) in
                    
                    if let error = error {
                        if case let WhiskError.httpError(description, statusCode) = error {
                            
                            print("Error: \(description) statusCode: \(statusCode))")
                            
                            //  actually any of these status codes are probably OK since the API call succeeded
                            if statusCode != 401 && statusCode != 404 && statusCode != 408 && statusCode != 500 {
                                XCTFail("Error: \(description) statusCode: \(statusCode))")
                            }
                            
                        }
                    } else if let reply = reply {
                        print("\(reply)")
                    } else {
                        print("No error or response")
                    }
                })
                
                expectation.fulfill()
                
            } catch {
                print(error)
                XCTFail("Error invoking trigger \(error)")
            }
            
            waitForExpectations(timeout: Timeout, handler: { error in
                
                if let error = error {
                    print("Error: \(error)")
                }
            })
            
        } else {
            XCTFail("No credentials available to run test")
        }
    }
    
}
