class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "https://ftp.gnu.org/gnu/commonc++/ucommon-7.0.0.tar.gz"
  sha256 "6ac9f76c2af010f97e916e4bae1cece341dc64ca28e3881ff4ddc3bc334060d7"

  livecheck do
    url :stable
    regex(/href=.*?ucommon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "1270ebc3579e74f3f044e88d7bca663efac0aa581ab214514f6345ade2a7ba16"
    sha256 big_sur:       "ca1bc13b9def95eb4839a628d6936ea799a284ac4d61dd53a77e77a046d3ffe1"
    sha256 catalina:      "3040baab77d1ff69f36ff21ec9259c8512170f361119e66b446a48b86f157320"
    sha256 mojave:        "34ef3423a4f8f0de02e05e8a00a5f1cb12bd0b9790103354792c24b7613ccb80"
    sha256 high_sierra:   "650bda43b289012df676190269cde7bb3be3e1337f4f2eddc6f472ae38bbda1c"
    sha256 sierra:        "0546fbc44ac1e17d8757b41a67b2d68b15bc872b4b19fea649e5d7fe54a4d2d4"
    sha256 el_capitan:    "57756d7809936ed885ef8fc7a284498ab12a5be6cc1ad41ad148dd45074fc322"
    sha256 x86_64_linux:  "f3624d1bf63f84175560167e9887d9fa88533aad863e697894683214091acb5b"
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
