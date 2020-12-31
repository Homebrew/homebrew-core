class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.tar.gz"
  sha256 "b3bc1a9bd0c19836c9709c318d41c19c11215a07514f49f89b40b9d50ab49325"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "c965fd423db73afdcce5ccde8af2783b5659ec2287bf02ae6a982fd6dcbd6292" => :big_sur
    sha256 "ef8520ec7f5004a2a6ef0fb1a6dc8254d3c6a056001fc0cb14d34e4a4965e722" => :arm64_big_sur
    sha256 "ef65c759c5097a36323fa9c77756468649e8d1980a3a4e05695c05e39568967c" => :catalina
    sha256 "28f4090610946a4eb207df102d841de23ced0d06ba31cb79e040d883906dcd4f" => :mojave
    sha256 "91dd0caca9bd3f38c439d5a7b6f68440c4274945615fae035ff0a369264b8a2f" => :high_sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-debug",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
