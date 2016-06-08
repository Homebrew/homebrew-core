class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/1.1.1.tar.gz"
  sha256 "faac0a80abae2f126d579d53caeec6cf8049320f7cccb9af195efadf3ff0cedf"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "02604fb0c966ee73ea446c3a17b12619436fb1ad4b99b2dba5519ecb471aab8b" => :el_capitan
    sha256 "d7079b2f51272ac2274f4b549610eed015db20f9f6b5103402882aaf5899faab" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    rake "install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = %w[
      UnitTests/fixtures/Images.xcassets
      UnitTests/fixtures/colors.txt
      UnitTests/fixtures/Localizable.strings
      UnitTests/fixtures/Message.storyboard
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
