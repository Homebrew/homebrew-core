class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://sunsite.icm.edu.pl/pub/unix/news/tin/v2.6/tin-2.6.3.tar.xz"
  sha256 "bf7ae8cfdc6ab6bc5aced4f08cf13687d8d6f9fa4be1690dfda5d123188d2217"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    sha256                               arm64_sequoia:  "0c24e34c9826132f8b79ab510c972948b6dfe5398deff08b918d86aed357271b"
    sha256                               arm64_sonoma:   "9b40007fa88eb76e74741528e34dc7418d27a7f0b14138998f6e886f7dd75125"
    sha256                               arm64_ventura:  "c355639ee07efc5e91c2a83bef8f43d1b1065b71ae275c34141cc52e36a17e9d"
    sha256                               arm64_monterey: "feb75a463cbc2f5773e421daa639681b62fec4070bddc9471bfc43773dee1339"
    sha256                               sonoma:         "c48a6ac3dd5f0225cba6caf19d7628e982ea92db0e2b5f500ac84e98f30563d2"
    sha256                               ventura:        "520261f163f2bc6b7165f86a8527d2148d65e3db7938306ae2842c8db775a2b0"
    sha256                               monterey:       "c0a4f84da414866ea207c136f06517895e91337c513f8163aa22faa972a9cc0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adc0899e6ec8ca68f5a7a8957dd26c64541bea25a155f208df11aee482a35b29"
  end

  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    # Remove bundled libraries
    %w[intl pcre].each { |l| rm_r(buildpath/l) }

    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-pcre2-config=#{Formula["pcre2"].opt_prefix}/bin/pcre2-config"
    system "make", "build"
    system "make", "install"
  end

  test do
    system bin/"tin", "-H"
  end
end
