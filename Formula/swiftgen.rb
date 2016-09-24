class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/3.0.0.tar.gz"
  sha256 "e95a6102d49013dc729363057d6fed4d670f87a73b9b023b4a7711d3dd10f8fc"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "4fbbfcc9b10ad825cfabb09b479686ccd374ac3a3fd1038532434fbbe5aabbe6" => :el_capitan
    sha256 "84dea0c4d8a0594f6aae49c7a8f0bc0fe7f8ba131cbdcff4239413cbf7724452" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    rake "install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = %w[
      UnitTests/fixtures/Images.xcassets
      UnitTests/fixtures/colors.txt
      UnitTests/fixtures/Localizable.strings
      UnitTests/fixtures/Storyboards-iOS/Message.storyboard
      UnitTests/fixtures/Fonts
      UnitTests/expected/Images-File-Default.swift.out
      UnitTests/expected/Colors-Txt-File-Default.swift.out
      UnitTests/expected/Strings-File-Default.swift.out
      UnitTests/expected/Storyboards-Message-Default.swift.out
      UnitTests/expected/Fonts-Dir-Default.swift.out
    ]
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen images --templatePath #{pkgshare/"templates/images-default.stencil"} #{fixtures}/Images.xcassets").strip
    assert_equal output, (fixtures/"Images-File-Default.swift.out").read.strip, "swiftgen images failed"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors-default.stencil"} #{fixtures}/colors.txt").strip
    assert_equal output, (fixtures/"Colors-Txt-File-Default.swift.out").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings-default.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"Strings-File-Default.swift.out").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards --templatePath #{pkgshare/"templates/storyboards-default.stencil"} #{fixtures}/Message.storyboard").strip
    assert_equal output, (fixtures/"Storyboards-Message-Default.swift.out").read.strip, "swiftgen storyboards failed"

    output = shell_output("#{bin}/swiftgen fonts --templatePath #{pkgshare/"templates/fonts-default.stencil"} #{fixtures}/Fonts").strip
    assert_equal output, (fixtures/"Fonts-Dir-Default.swift.out").read.strip, "swiftgen fonts failed"
  end
end
