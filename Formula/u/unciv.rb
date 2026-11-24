class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/5.0.3/Unciv.jar"
  sha256 "26f584dd564f1ffed598058556810ed7436301d01395293ffc29ea12436c45ce"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "a862b40c2a082090348167c3491a962bf23add1bc53d06e9b127e8250ab39da5"
    sha256 cellar: :any_skip_relocation, all: "5ccd99bf617592dc40238f95b81718fa24b7ce41d4618e88d1896805a5d1f06e"
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
