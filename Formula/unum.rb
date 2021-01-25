class Unum < Formula
  desc "Interconvert numbers, Unicode, and HTML/XHTML entities"
  homepage "https://www.fourmilab.ch/webtools/unum/"
  url "https://www.fourmilab.ch/webtools/unum/prior-releases/3.2/unum.tar.gz"
  sha256 "d290070f4be54addacac7318dfb2c0bfde71690bba51f99ecf64671b71801d2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "afd2c20350cee5b3af9ae6f0c539be5ae7c3c4c882056671242ac447e655166d" => :big_sur
    sha256 "68d0229aa7501537118e7e352c13a37cd5756517f176a7751f9c758e5790c493" => :arm64_big_sur
    sha256 "e2ee19c28d058e0874fc5eb6008229305c471eac5a60c88ab99ef0917b907eb7" => :catalina
    sha256 "e2ee19c28d058e0874fc5eb6008229305c471eac5a60c88ab99ef0917b907eb7" => :mojave
    sha256 "270c0296d036b4be85368539d895d27f0630e3f6a4106cc8758747e5f2371471" => :high_sierra
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
