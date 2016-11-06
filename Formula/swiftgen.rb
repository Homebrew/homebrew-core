class Swiftgen < Formula
  desc "Collection of Swift tools to generate Swift code"
  homepage "https://github.com/AliSoftware/SwiftGen"
  url "https://github.com/AliSoftware/SwiftGen/archive/3.0.1.tar.gz"
  sha256 "eca63a8dbb011e28cf58b11f06f846e5efb9be22c40f949d548ec9bda329291a"
  head "https://github.com/AliSoftware/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "1625b77bb922202dec6a7371b8ae6a42f8017fd7284ba59542ca024b6e051295" => :sierra
    sha256 "f426532be8eb66707661ae7282cad21bb1b6d9df5c04ae38da44020faa9537ab" => :el_capitan
  end

  depends_on :xcode => "8.0"

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
