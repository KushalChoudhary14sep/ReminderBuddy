
import Foundation

let fileManager = FileManager.default
let swiftgenPath = "/usr/local/bin/swiftgen"
let xcodegenPath = "/usr/local/bin/xcodegen"

let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

print("Current Directory: \(currentDirectoryURL)")

let projectYAML = """
name: ReminderBuddy
options:
  bundleIdPrefix: "com.lenscorp.ReminderBuddy"
  developmentRegion: en
targets:
  ReminderBuddy:
    postBuildScripts:
      - script: |
          cd $SRCROOT
          echo "POST BUILT SCRIPT"
          $PODS_ROOT/FirebaseCrashlytics/run
          /opt/homebrew/bin/swiftgen
    type: application
    platform: iOS
    deploymentTarget: "16.0"
    sources:
      - ReminderBuddy
    settings:
      base:
        PRODUCT_NAME: ReminderBuddy
        LAUNCH_SCREEN_STORYBOARD_NAME: Splash.storyboard
        PRODUCT_BUNDLE_IDENTIFIER: "com.lenscorp.ReminderBuddy"

  ReminderBuddyTests:
    type: bundle.unit-test
    platform: iOS
    sources:
      - ReminderBuddyTests
    dependencies:
      - target: ReminderBuddy
    settings:
      base:
        PRODUCT_NAME: ReminderBuddyTests
        PRODUCT_BUNDLE_IDENTIFIER: "com.lenscorp.ReminderBuddyTests"

  ReminderBuddyUITests:
    type: bundle.ui-testing
    platform: iOS
    sources:
      - ReminderBuddyUITests
    dependencies:
      - target: ReminderBuddy
    settings:
      base:
        PRODUCT_NAME: ReminderBuddyUITests
        PRODUCT_BUNDLE_IDENTIFIER: "com.lenscorp.ReminderBuddyUITests"

settings:
  base:
    PRODUCT_NAME: ReminderBuddy
    LAUNCH_SCREEN_STORYBOARD_NAME: Splash.storyboard
    PRODUCT_BUNDLE_IDENTIFIER: "com.lenscorp.ReminderBuddy"
"""

print("Generating project.yml...")
do {
    try projectYAML.write(toFile: "project.yml", atomically: true, encoding: String.Encoding.utf8)
    print("project.yml generated successfully.")
} catch {
    print("Failed to generate project.yml: \(error)")
    exit(1)
}

let process = Process()
process.launchPath = "/bin/sh"
process.arguments = [FileManager.default.currentDirectoryPath + "/project_generator.sh"]

let pipe = Pipe()
process.standardOutput = pipe
process.standardError = pipe

// Start observing for data availability on the pipe
pipe.fileHandleForReading.readabilityHandler = { pipe in
    if let line = String(data: pipe.availableData, encoding: .utf8) {
                // Handle each line of output here
        if line.count > 1 {
            print("Shell script output: \(line)")
        }
    }
}
process.launch()

process.waitUntilExit()
let status = process.terminationStatus
print("Shell script exited with status \(status)")

