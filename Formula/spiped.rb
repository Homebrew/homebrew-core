class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.2.tgz"
  sha256 "05d4687d12d11d7f9888d43f3d80c541b7721c987038d085f71c91bb06204567"

  livecheck do
    url :homepage
    regex(/href=.*?spiped[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "63451c713c91962ed596254ff1924de72d6adc4bb7d950082d420cafa70596a0"
    sha256 cellar: :any,                 arm64_big_sur:  "3df7565403ad24361e05d3661242f8724bde49bdee1124bcc07aa234dbdcecf2"
    sha256 cellar: :any,                 monterey:       "b343cf4da6e41a3c30d76ea2e25bf18c1e63d0479e7ceb13e8764232a035b727"
    sha256 cellar: :any,                 big_sur:        "4e78ef161701b82728993c1107fbb155bb9a17cea82df586c9a1df520ec8d656"
    sha256 cellar: :any,                 catalina:       "f3edfef25280658dbeaee09e50d2b284a5d9768ffb2632502b3bfc050590e073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5688ae1fdf0012b91c336d8a802358a3a248d83ff97fa882ec5319454e1f8823"
  end

  depends_on "openssl@1.1"

  on_macos do
    depends_on "bsdmake" => :build
  end

  def install
    man1.mkpath
    make = OS.mac? ? "bsdmake" : "make"
    system make, "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
