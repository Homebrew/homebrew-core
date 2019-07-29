class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "https://ftp.gnu.org/gnu/commonc++/ucommon-7.0.0.tar.gz"
  sha256 "6ac9f76c2af010f97e916e4bae1cece341dc64ca28e3881ff4ddc3bc334060d7"

  bottle do
    sha256 "34ef3423a4f8f0de02e05e8a00a5f1cb12bd0b9790103354792c24b7613ccb80" => :mojave
    sha256 "650bda43b289012df676190269cde7bb3be3e1337f4f2eddc6f472ae38bbda1c" => :high_sierra
    sha256 "0546fbc44ac1e17d8757b41a67b2d68b15bc872b4b19fea649e5d7fe54a4d2d4" => :sierra
    sha256 "57756d7809936ed885ef8fc7a284498ab12a5be6cc1ad41ad148dd45074fc322" => :el_capitan
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
