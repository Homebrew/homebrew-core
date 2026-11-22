class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/5.0.2/Unciv.jar"
  sha256 "aa2f1002ff44ad3cffe37d169d36f9aa292c9a2662c96a6936ad4714cef4988d"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "9a5070ac1306b460400ee6311742c15e1a0a114df832659f4d6b3163aae28a61"
    sha256 cellar: :any_skip_relocation, all: "01197c947d69a9d5c1eebcede4e1ca9ce62c2ea7c7a57d1a514c48df87b62785"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec/"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}/unciv --version")
  end
end
