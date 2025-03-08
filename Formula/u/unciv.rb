class Unciv < Formula
  desc "Open-source Android/Desktop remake of Civ V"
  homepage "https://github.com/yairm210/Unciv"
  url "https://github.com/yairm210/Unciv/releases/download/4.15.15/Unciv.jar"
  sha256 "44f0a6c6d9a6e66491db4dbc1c9790753cc6f85e6cc7922c9ebb385321af9063"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?patch\d*)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a52da9bcf45a5442e83b18bf67a31f8bf855e78cddb92e11f0d92b0ea6fe040"
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
