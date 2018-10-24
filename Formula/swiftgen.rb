class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      :tag => "6.0.2",
      :revision => "b34e66fbeb75f9f625f31cb8a096866dba1ad321"
  head "https://github.com/SwiftGen/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "ca29c729d9c05e52e26fee13cad5cd544f3b68c4381e57875c7cdcae7327d298" => :mojave
    sha256 "beac92d79d985ea1d9adbdcdc992f4e2d3fa95175415ea5146895fa58bf2a27b" => :high_sierra
  end

  depends_on "ruby" => :build if MacOS.version <= :sierra
  depends_on :xcode => ["10.0", :build]

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
      "Tests/Fixtures/Resources/Colors/colors.xml" => "colors.xml",
      "Tests/Fixtures/Resources/Fonts" => "Fonts",
      "Tests/Fixtures/Resources/IB-iOS" => "IB-iOS",
      "Tests/Fixtures/Resources/Plist/good" => "Plist",
      "Tests/Fixtures/Resources/Strings/Localizable.strings" => "Localizable.strings",
      "Tests/Fixtures/Resources/XCAssets" => "XCAssets",
      "Tests/Fixtures/Resources/YAML/good" => "YAML",
      "Tests/Fixtures/Generated/Colors/swift4-context-defaults.swift" => "colors.swift",
      "Tests/Fixtures/Generated/Fonts/swift4-context-defaults.swift" => "fonts.swift",
      "Tests/Fixtures/Generated/IB-iOS/scenes-swift4-context-all.swift" => "ib-scenes.swift",
      "Tests/Fixtures/Generated/Plist/runtime-swift4-context-all.swift" => "plists.swift",
      "Tests/Fixtures/Generated/Strings/structured-swift4-context-localizable.swift" => "strings.swift",
      "Tests/Fixtures/Generated/XCAssets/swift4-context-all.swift" => "xcassets.swift",
      "Tests/Fixtures/Generated/YAML/inline-swift4-context-all.swift" => "yaml.swift",
    }
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors/swift4.stencil"} #{fixtures}/colors.xml").strip
    assert_equal output, (fixtures/"colors.swift").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen fonts --templatePath #{pkgshare/"templates/fonts/swift4.stencil"} #{fixtures}/Fonts").strip
    assert_equal output, (fixtures/"fonts.swift").read.strip, "swiftgen fonts failed"

    output = shell_output("#{bin}/swiftgen ib --templatePath #{pkgshare/"templates/ib/scenes-swift4.stencil"} --param module=SwiftGen #{fixtures}/IB-iOS").strip
    assert_equal output, (fixtures/"ib-scenes.swift").read.strip, "swiftgen ib failed"

    output = shell_output("#{bin}/swiftgen plist --templatePath #{pkgshare/"templates/plist/runtime-swift4.stencil"} #{fixtures}/Plist").strip
    assert_equal output, (fixtures/"plists.swift").read.strip, "swiftgen plist failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings/structured-swift4.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"strings.swift").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen xcassets --templatePath #{pkgshare/"templates/xcassets/swift4.stencil"} #{fixtures}/XCAssets/*.xcassets").strip
    assert_equal output, (fixtures/"xcassets.swift").read.strip, "swiftgen xcassets failed"

    output = shell_output("#{bin}/swiftgen yaml --templatePath #{pkgshare/"templates/yaml/inline-swift4.stencil"} #{fixtures}/YAML").strip
    assert_equal output, (fixtures/"yaml.swift").read.strip, "swiftgen yaml failed"
  end
end
