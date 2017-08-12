class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      :tag => "5.0.0",
      :revision => "6bc2699f84510ce8cdee94169a46d5870b1e4ac6"
  head "https://github.com/SwiftGen/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "a54d2b9065eb4d918989b17acf1ad403f6c6892a80c6081c84d6d94af82484dd" => :sierra
    sha256 "334be48adca8c6ce711e8d6e25cb7aa15550a51159f967377d049cf7d3c78427" => :el_capitan
  end

  depends_on :xcode => ["8.3", :build]

  def install
    # Disable swiftlint Build Phase to avoid build errors if versions mismatch
    ENV["NO_CODE_LINT"]="1"

    # Install bundler, then use it to `rake cli:install` SwiftGen
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install"
    system "bundle", "exec", "rake", "cli:install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = {
      "Resources/Fixtures/XCAssets/Images.xcassets" => "Images.xcassets",
      "Resources/Fixtures/Colors/colors.xml" => "colors.xml",
      "Resources/Fixtures/Strings/Localizable.strings" => "Localizable.strings",
      "Resources/Fixtures/Storyboards-iOS" => "Storyboards-iOS",
      "Resources/Fixtures/Fonts" => "Fonts",
      "Resources/Tests/Expected/XCAssets/swift3-context-defaults.swift" => "images.swift",
      "Resources/Tests/Expected/Colors/swift3-context-defaults.swift" => "colors.swift",
      "Resources/Tests/Expected/Strings/structured-swift3-context-localizable.swift" => "strings.swift",
      "Resources/Tests/Expected/Storyboards-iOS/swift3-context-all.swift" => "storyboards.swift",
      "Resources/Tests/Expected/Fonts/swift3-context-defaults.swift" => "fonts.swift",
    }
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen xcassets --templatePath #{pkgshare/"templates/xcassets/swift3.stencil"} #{fixtures}/Images.xcassets").strip
    assert_equal output, (fixtures/"images.swift").read.strip, "swiftgen images failed"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors/swift3.stencil"} #{fixtures}/colors.xml").strip
    assert_equal output, (fixtures/"colors.swift").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings/structured-swift3.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"strings.swift").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards --templatePath #{pkgshare/"templates/storyboards/swift3.stencil"} #{fixtures}/Storyboards-iOS").strip
    assert_equal output, (fixtures/"storyboards.swift").read.strip, "swiftgen storyboards failed"

    output = shell_output("#{bin}/swiftgen fonts --templatePath #{pkgshare/"templates/fonts/swift3.stencil"} #{fixtures}/Fonts").strip
    assert_equal output, (fixtures/"fonts.swift").read.strip, "swiftgen fonts failed"
  end
end
