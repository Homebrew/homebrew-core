class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "https://ftp.gnu.org/gnu/commonc++/ucommon-7.0.0.tar.gz"
  sha256 "6ac9f76c2af010f97e916e4bae1cece341dc64ca28e3881ff4ddc3bc334060d7"

  bottle do
    sha256 "dc45edfafc90739e0bdbb5f44ac45151e2721737e5ea5fd8425d6f5398ef9889" => :sierra
    sha256 "eea46c279fd145ec3d8a7a3d9b751465341e8f69aa507bd6f7025d9437019b0c" => :el_capitan
    sha256 "6237fa697417c4defdfc513c7b56e93ce7156b5b38a4164e7a27c9e285688c0a" => :yosemite
    sha256 "6fe4b60fa239460cf900a9660ab08275865d167c0811e3f8069307c19b2b8060" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  # Fix build, reported by email to bug-commoncpp@gnu.org on 2017-10-05
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/77f0d9d2/ucommon/cachelinesize.patch"
    sha256 "46aef9108e2012362b6adcb3bea2928146a3a8fe5e699450ffaf931b6db596ff"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--enable-socks",
                          "--with-sslstack=gnutls", "--with-pkg-config"
    system "make", "install"
  end

  test do
    system "#{bin}/ucommon-config", "--libs"
  end
end
