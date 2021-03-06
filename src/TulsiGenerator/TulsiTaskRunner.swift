// Copyright 2016 The Tulsi Authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation


/// Wraps the standard TaskRunner and injects Tulsi-specific environment variables.
public final class TulsiTaskRunner {

  public typealias CompletionHandler = (TaskRunner.CompletionInfo) -> Void

  private static var defaultEnvironment: [String: String] = {
    var environment = NSProcessInfo.processInfo().environment
    if let cfBundleVersion = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
      environment["TULSI_VERSION"] = cfBundleVersion
    }
    return environment
  }()

  /// Prepares an NSTask using the given launch binary with the given arguments that will collect
  /// output and passing it to a terminationHandler.
  public static func createTask(launchPath: String,
                                arguments: [String]? = nil,
                                environment: [String: String]? = nil,
                                terminationHandler: CompletionHandler) -> NSTask {

    var env = defaultEnvironment
    if let environment = environment {
      for (key, value) in environment {
        env[key] = value
      }
    }
    return TaskRunner.createTask(launchPath,
                                 arguments: arguments,
                                 environment: env,
                                 terminationHandler: terminationHandler)
  }
}
