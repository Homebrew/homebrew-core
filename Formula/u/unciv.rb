class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/4.15.14/Unciv.jar"
  sha256 "23ba482998b212579f53f677e014fc12cd7b9fa8fe3ffb6c4dbe9a03fcf1be6c"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^(\d+\.\d+\.\d+(-patch\d+)?)$/i)
  end

  depends_on "openjdk"

  def install
    libexec.install "Unciv.jar"
    bin.write_jar_script libexec/"Unciv.jar", "unciv"
  end

  test do
    # Unciv is a GUI application, so there is no cli functionality to test
    assert_match version.to_str, shell_output("#{bin}/unciv --version")
  end
end
