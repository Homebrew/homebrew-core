class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.6/tin-2.6.2.tar.xz"
  sha256 "91df3cc009017ac0fcc6bb8b625784a0a006f921fb0fd5b87229f74edb1d068c"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "279325cdda955514a69d824ce8a10a5d93e2118561133fa8b1adc5a3c847e4c6"
    sha256                               arm64_monterey: "20081eeca41e91c2cd9d23313fc97180e92f19f6f375dce9dc7a361298e5f709"
    sha256                               arm64_big_sur:  "e7d9f551293c92c6a2726856204303eb18e122e24693bbf1b4efb93a51c2c8b5"
    sha256                               ventura:        "bd598a16a48913db70e0ee74bf976b9ad62a7e5219046fdf587d6578f768cfbf"
    sha256                               monterey:       "7b2fab82e93e8a5a769cb83a781ba4e95b14b623d40c14b93d160c8075a280f5"
    sha256                               big_sur:        "26d6c3893d0db776c0ed9d03a9436739137fa1b9c006b19449702066fe11e0e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "386f648f9235e7ddfa23de2e0e5a6e6cf7af4c4045ca316037819b002640adbb"
  end

  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    # Remove bundled libraries
    %w[intl pcre].each { |l| (buildpath/l).rmtree }

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-pcre2-config=#{Formula["pcre2"].opt_prefix}/bin/pcre2-config"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
