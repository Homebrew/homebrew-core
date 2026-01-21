class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftpmirror.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz"
  sha256 "0329d7788fbef113fa82cb80889ca197a344ce0df7646fe000974c5d714363a6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "860131f9432cb4fce12c4ffc6440e91373d40d9cf79db0e09498029c9055d97c"
    sha256 arm64_sequoia: "a28e8dfcc909b1fcf3d7084cb85b2437c34f75c96f837f178b22cc7501c3c056"
    sha256 arm64_sonoma:  "9ceddadff536aea2594d32c5a4f6c9f87d0d7d215c4e79b9d828356b6004e11c"
    sha256 tahoe:         "4f43bf3f89a5ec53f3f1b567c37ac0e5ebcfe9fb3bb7a7a418fb2ebb9cfbe0e6"
    sha256 sequoia:       "60d14960da05f3e0ac1edfae9e6ae9d086b06823fcf82219279d2d2980de8ebb"
    sha256 sonoma:        "5def5754597c20c93f9d4cfad57f6590be2f966f4a138e4c6a67c937fd45a1ad"
    sha256 arm64_linux:   "26bc9ccc084ae18c42003b4efdca2439a5c8a8986cdb839db0de8011c16c46e9"
    sha256 x86_64_linux:  "8c1fcbbb14cf2b3f7279b740636a6402db90287ae6c8dff8c6467ce39f56fe37"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_linux do
    depends_on "gettext"
    depends_on "libunistring"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  def post_install
    info_dir = HOMEBREW_PREFIX/"share/info/dir"
    info_dir.delete if info_dir.exist?
    info_dir.dirname.glob(["*.info", "*.info.gz"]) do |f|
      quiet_system("#{bin}/install-info", "--quiet", f, info_dir)
    end
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS

    system bin/"makeinfo", "test.texinfo"
    assert_match "Hello World!", (testpath/"test.info").read
  end
end
