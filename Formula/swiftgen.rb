class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      :tag      => "6.2.0",
      :revision => "c62c7ff1c86323b9c1e4c12bccfca19737dd2e56"
  head "https://github.com/SwiftGen/SwiftGen.git", :branch => "stable"

  bottle do
    cellar :any
    sha256 "d3a00e098b7c4dd3e6add33e935976a52697a67384b0133b9c37e510f8ce4271" => :mojave
    sha256 "786366406526b11d0958340597eb98e6e3d14971ca0a5097bfb11bae9a64cb03" => :high_sierra
  end

  depends_on "ruby" => :build if MacOS.version <= :sierra
  depends_on :xcode => ["11.4", :build]

  def install
    # Disable swiftlint build phase to avoid build errors if versions mismatch
    ENV["NO_CODE_LINT"] = "1"

    # Install bundler, then use it to `rake cli:install` SwiftGen
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install", "--without", "development", "release"
    system "bundle", "exec", "rake", "cli:install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = {
      "Tests/Fixtures/Resources/Colors/colors.xml"                           => "colors.xml",
      "Tests/Fixtures/Resources/CoreData/Model.xcdatamodeld"                 => "Model.xcdatamodeld",
      "Tests/Fixtures/Resources/Fonts"                                       => "Fonts",
      "Tests/Fixtures/Resources/IB-iOS"                                      => "IB-iOS",
      "Tests/Fixtures/Resources/Plist/good"                                  => "Plist",
      "Tests/Fixtures/Resources/Strings/Localizable.strings"                 => "Localizable.strings",
      "Tests/Fixtures/Resources/XCAssets"                                    => "XCAssets",
      "Tests/Fixtures/Resources/YAML/good"                                   => "YAML",
      "Tests/Fixtures/Generated/Colors/swift5/defaults.swift"                => "colors.swift",
      "Tests/Fixtures/Generated/CoreData/swift5/defaults.swift"              => "coredata.swift",
      "Tests/Fixtures/Generated/Fonts/swift5/defaults.swift"                 => "fonts.swift",
      "Tests/Fixtures/Generated/IB-iOS/scenes-swift5/all.swift"              => "ib-scenes.swift",
      "Tests/Fixtures/Generated/Plist/runtime-swift5/all.swift"              => "plists.swift",
      "Tests/Fixtures/Generated/Strings/structured-swift5/localizable.swift" => "strings.swift",
      "Tests/Fixtures/Generated/XCAssets/swift5/all.swift"                   => "xcassets.swift",
      "Tests/Fixtures/Generated/YAML/inline-swift5/all.swift"                => "yaml.swift",
    }
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    assert_equal shell_output("#{bin}/swiftgen run colors --templatePath " \
                              "#{pkgshare/"templates/colors/swift5.stencil"} #{fixtures}/colors.xml").strip,
      (fixtures/"colors.swift").read.strip, "swiftgen run colors failed"

    assert_equal shell_output("#{bin}/swiftgen run coredata --templatePath " \
                              "#{pkgshare/"templates/coredata/swift5.stencil"} #{fixtures}/Model.xcdatamodeld").strip,
      (fixtures/"coredata.swift").read.strip, "swiftgen run coredata failed"

    assert_equal shell_output("#{bin}/swiftgen run fonts --templatePath " \
                              "#{pkgshare/"templates/fonts/swift5.stencil"} #{fixtures}/Fonts").strip,
      (fixtures/"fonts.swift").read.strip, "swiftgen run fonts failed"

    assert_equal shell_output("#{bin}/swiftgen run ib --templatePath " \
                              "#{pkgshare/"templates/ib/scenes-swift5.stencil"} --param module=SwiftGen " \
                              "#{fixtures}/IB-iOS").strip,
      (fixtures/"ib-scenes.swift").read.strip, "swiftgen run ib failed"

    assert_equal shell_output("#{bin}/swiftgen run plist --templatePath " \
                              "#{pkgshare/"templates/plist/runtime-swift5.stencil"} #{fixtures}/Plist").strip,
      (fixtures/"plists.swift").read.strip, "swiftgen run plist failed"

    assert_equal shell_output("#{bin}/swiftgen run strings --templatePath " \
                              "#{pkgshare/"templates/strings/structured-swift5.stencil"} " \
                              "#{fixtures}/Localizable.strings").strip,
      (fixtures/"strings.swift").read.strip, "swiftgen run strings failed"

    assert_equal shell_output("#{bin}/swiftgen run xcassets --templatePath " \
                              "#{pkgshare/"templates/xcassets/swift5.stencil"} " \
                              "#{fixtures}/XCAssets/*.xcassets").strip,
      (fixtures/"xcassets.swift").read.strip, "swiftgen run xcassets failed"

    assert_equal shell_output("#{bin}/swiftgen run yaml --templatePath " \
                              "#{pkgshare/"templates/yaml/inline-swift5.stencil"} --filter '.(json|ya?ml)$' " \
                              "#{fixtures}/YAML").strip,
      (fixtures/"yaml.swift").read.strip, "swiftgen run yaml failed"
  end
end
