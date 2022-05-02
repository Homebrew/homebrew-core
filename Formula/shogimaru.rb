class Shogimaru < Formula
  desc "Shogi GUI supporting USI protocol"
  homepage "https://shogimaru.com/index.en.html"
  url "https://github.com/shogimaru/shogimaru/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "2fda10886baa8f84dd403283a768e728c0d7cd7aac2238c9b83d79728234376b"
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
    assert_match "Shogimaru", shell_output("#{bin}/shogimaru --version 2>/dev/null")
    assert_match "Usage:", shell_output("#{bin}/shogimaru --help 2>/dev/null")
  end
end
