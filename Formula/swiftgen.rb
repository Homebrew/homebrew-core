class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      :tag => "4.2.1",
      :revision => "0ce335af8d3720e18b3553aede1205ae678de096"
  head "https://github.com/SwiftGen/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "a54d2b9065eb4d918989b17acf1ad403f6c6892a80c6081c84d6d94af82484dd" => :sierra
    sha256 "334be48adca8c6ce711e8d6e25cb7aa15550a51159f967377d049cf7d3c78427" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    # Disable swiftlint Build Phase to avoid build errors if versions mismatch
    ENV["NO_CODE_LINT"]="1"

    rake "cli:install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = {
      "Resources/Fixtures/Images/Images.xcassets" => "Images.xcassets",
      "Resources/Fixtures/Colors/colors.txt" => "colors.txt",
      "Resources/Fixtures/Strings/Localizable.strings" => "Localizable.strings",
      "Resources/Fixtures/Storyboards-iOS" => "Storyboards-iOS",
      "Resources/Fixtures/Fonts" => "Fonts",
      "Resources/Tests/Expected/Images/default-context-defaults.swift" => "images.swift",
      "Resources/Tests/Expected/Colors/default-context-text-defaults.swift" => "colors.swift",
      "Resources/Tests/Expected/Strings/default-context-defaults.swift" => "strings.swift",
      "Resources/Tests/Expected/Storyboards-iOS/default-context-all.swift" => "storyboards.swift",
      "Resources/Tests/Expected/Fonts/default-context-defaults.swift" => "fonts.swift",
    }
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen images --templatePath #{pkgshare/"templates/images-default.stencil"} #{fixtures}/Images.xcassets").strip
    assert_equal output, (fixtures/"images.swift").read.strip, "swiftgen images failed"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors-default.stencil"} #{fixtures}/colors.txt").strip
    assert_equal output, (fixtures/"colors.swift").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings-default.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"strings.swift").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards --templatePath #{pkgshare/"templates/storyboards-default.stencil"} #{fixtures}/Storyboards-iOS").strip
    assert_equal output, (fixtures/"storyboards.swift").read.strip, "swiftgen storyboards failed"

    output = shell_output("#{bin}/swiftgen fonts --templatePath #{pkgshare/"templates/fonts-default.stencil"} #{fixtures}/Fonts").strip
    assert_equal output, (fixtures/"fonts.swift").read.strip, "swiftgen fonts failed"
  end
end
