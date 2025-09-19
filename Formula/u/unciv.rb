class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/4.18.1/Unciv.jar"
  sha256 "cdba02b99f4255daa21090c0b372869fef96e3b7d8f06a3d3d54fd82291e86d3"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fc8c7d74924d0ebe8e35d6a843306fbe4cd01c671af6b22a616d2a05360f625"
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
