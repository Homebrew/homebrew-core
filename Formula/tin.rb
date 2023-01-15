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
    sha256 arm64_ventura:  "c83d7b30ce4bafc59bf1275e5d82bfafb4a8a87a27c62280996df5a7f7b48d38"
    sha256 arm64_monterey: "f1b52ebb8e87716be76d7edc0680c0cff6aac863fcf3ad2a53523659038b4775"
    sha256 arm64_big_sur:  "04f1a7eac2476bcadd410b3472e507ff6002e87f553f1746d9b2bbef4ba3617a"
    sha256 ventura:        "41fca2aff459ad6ca92134475d95a0f7909500f6475469676835a003d3c173a4"
    sha256 monterey:       "784a75aede2e6fb34144c1dfea6296b0affde6c24fbd66d6f67f108b8c5fc995"
    sha256 big_sur:        "eb252538896e11bbfba786441a4f71d424b054db857faa573710e0d1c8ffeef8"
    sha256 x86_64_linux:   "30b3b8d2c6b1c01e37e1a3f1248ad70f9f2b0827e2de8d7f16653acba44b761e"
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
