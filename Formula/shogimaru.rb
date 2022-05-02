class Shogimaru < Formula
  desc "Shogi GUI supporting USI protocol"
  homepage "https://shogimaru.com/index.en.html"
  url "https://github.com/shogimaru/shogimaru/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "a1319cee822e6a673ecf89dca7b0491ab6909c59954842495f40e3f7f78462cb"
  license "MIT"
  head "https://github.com/shogimaru/shogimaru.git", branch: "develop"

  depends_on "qt"

  on_macos do
    depends_on "libiconv"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "qmake", "-recursive", "CONFIG+=release", "target.path=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Shogimaru", shell_output("#{bin}/shogimaru --version")
    assert_match "Usage:", shell_output("#{bin}/shogimaru --help")
  end
end
