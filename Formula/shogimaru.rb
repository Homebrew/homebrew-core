class Shogimaru < Formula
  desc "Shogi GUI supporting USI protocol"
  homepage "https://shogimaru.com/index.en.html"
  url "https://github.com/shogimaru/shogimaru/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "152f18e381e6d08abae8a494002387a9ac2786104c8c5e98ca2c4fd011e11bca"
  license "MIT"
  head "https://github.com/shogimaru/shogimaru.git", branch: "develop"

  depends_on xcode: :build
  depends_on "qt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "qmake", "-recursive", "CONFIG+=release", "target.path=#{prefix}/bin"
    system "make"
    system "make", "install"
  end

  test do
    #system "shogimaru"
  end
end
