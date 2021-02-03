class Unum < Formula
  desc "Interconvert numbers, Unicode, and HTML/XHTML entities"
  homepage "https://www.fourmilab.ch/webtools/unum/"
  url "https://www.fourmilab.ch/webtools/unum/prior-releases/3.2/unum.tar.gz"
  sha256 "d290070f4be54addacac7318dfb2c0bfde71690bba51f99ecf64671b71801d2a"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68d0229aa7501537118e7e352c13a37cd5756517f176a7751f9c758e5790c493"
    sha256 cellar: :any_skip_relocation, big_sur:       "afd2c20350cee5b3af9ae6f0c539be5ae7c3c4c882056671242ac447e655166d"
    sha256 cellar: :any_skip_relocation, catalina:      "e2ee19c28d058e0874fc5eb6008229305c471eac5a60c88ab99ef0917b907eb7"
    sha256 cellar: :any_skip_relocation, mojave:        "e2ee19c28d058e0874fc5eb6008229305c471eac5a60c88ab99ef0917b907eb7"
    sha256 cellar: :any_skip_relocation, high_sierra:   "270c0296d036b4be85368539d895d27f0630e3f6a4106cc8758747e5f2371471"
  end

  def install
    system "pod2man", "unum.pl", "unum.1"
    bin.install "unum.pl" => "unum"
    man1.install "unum.1"
  end

  test do
    assert_match "LATIN SMALL LETTER X", shell_output("unum x").strip
  end
end
