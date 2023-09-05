class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.40.tgz"
  sha256 "bccae5380c1c1d6be25dccfb7c2eaa8364ba3401aafaee61e3c5574203c27fd5"
  license "0BSD"
  revision 1

  livecheck do
    url "https://www.tarsnap.com/download.html"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e022219045b24e6d876bf97f8a092a82449932410ba7ebfa58d860dd92608ff"
    sha256 cellar: :any,                 arm64_monterey: "8c765adcc21196986e44b11c168521f40ca7a6e6a9c1432bfa0e92933b28e920"
    sha256 cellar: :any,                 arm64_big_sur:  "d99d8d2ea8f5b689fda5ab16779f19ccb66ac245743a0b3a968e853113e8d3ae"
    sha256 cellar: :any,                 ventura:        "d00d96a1ac3b3135985a30b282018fd3ca039532fd4fea10dce88149f0d904c7"
    sha256 cellar: :any,                 monterey:       "77f225c14c952a1c5786d80fa284936fb35fbea06ea90522b39a39b8f1d8cd14"
    sha256 cellar: :any,                 big_sur:        "a81400622c552d684b783e239cdd3f3cdc139d2a1e65ef41eed1685efe89d95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511945c57b370981aeab675422da88d71b63a2442e7b55b6d9a7a4071e2668f8"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "e2fsprogs" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bash-completion-dir=#{bash_completion}
      --without-lzma
      --without-lzmadec
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
