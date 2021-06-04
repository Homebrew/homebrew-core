class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.1.0.tar.gz"
  sha256 "79574395d83f628b0b325127b2dcea9b3e91dd6510dafd036679fae8998bcf6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fb3a2df6c300581e093bf8c3525c900a39a21d9767a7afde92bf2ab722da15d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c63cbc63ca7608a701da92d6ce3b62ad8af9ab29385a1af85a64ca582a37957b"
    sha256 cellar: :any_skip_relocation, catalina:      "3a77a83a1c61aacdfbb4a2ab010e3149c90004ec305f9dda2c66d883d182513c"
    sha256 cellar: :any_skip_relocation, mojave:        "a629b57b4b16fa825463b6d28ef102d36ec61fe407d17dde23fb423898cbef43"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
