class Swiftplate < Formula
  desc "Cross-platform Swift framework templates from the command-line"
  homepage "https://github.com/JohnSundell/SwiftPlate"
  url "https://github.com/JohnSundell/SwiftPlate/archive/1.2.1.tar.gz",
    :tag => "1.2.1"
  sha256 "c4a47411340c88dbacc87d63daf69eed12c80cbc2e1fc8c02cc8d6b2966c04b9"
  head "https://github.com/JohnSundell/SwiftPlate.git"
  depends_on :xcode => "8.2"

  def install
    xcodebuild "-project",
        "SwiftPlate.xcodeproj",
        "-scheme", "SwiftPlate",
        "-configuration", "Release",
        "CONFIGURATION_BUILD_DIR=build",
        "SYMROOT=."
    bin.install "build/swiftplate"
  end

  test do
    system "#{bin}/swiftplate", "--destination", ".", "--project", "testProject", "--name", "testUser", "--email", "test@example.com", "--url", "https://github.com/johnsundell/swiftplate", "--organization", "exampleOrg", "--force"

    (testpath/"test.py").write <<-EOS.undent
        # -*- coding: utf-8 -*-
        import sys
        import os
        from os.path import join, getsize

        rootFiles = set(['LICENSE', 'Package.swift', 'README.md', sys.argv[1] + '.podspec'])
        configFiles = set([sys.argv[1] + '.plist', sys.argv[1] + 'Tests.plist'])
        sourceFiles = set([sys.argv[1]+ '.swift'])
        testDirs = set([sys.argv[1] + 'Tests'])

        for root, dirs, files in os.walk('.'):
            if root == '.':
                if sys.argv[1] + '.xcodeproj' not in dirs:
                    print("xcode project not found")
                    exit(1)
                if not rootFiles.issubset(files):
                    print("root level files not found")
                    exit(1)
            if root == './Configs':
                if not configFiles.issubset(files):
                    print("Config files not found")
                    exit(1)
            if root == './Sources':
                if not sourceFiles.issubset(files):
                    print("Source files not found")
                    exit(1)
            if root == './Tests':
                if not testDirs.issubset(dirs):
                    print("Test Directories not found")
                    exit(1)
        print("All tests run successfully ⭐⭐⭐⭐⭐")
        exit(0)
    EOS
    system "python", "test.py", "testProject"
  end
end
