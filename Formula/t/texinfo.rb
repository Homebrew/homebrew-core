class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.1.1.tar.xz"
  sha256 "31ae37e46283529432b61bee1ce01ed0090d599e606fc6a29dca1f77c76a6c82"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "9082daa6193349571bd407956bc3fb549368a7347ccbb0a86b5758dbbaccf126"
    sha256 arm64_sonoma:  "aa6c8308ee525e1e4ed0b472ca83e9f93eb87b41b4e2194bc32dda0daaf83400"
    sha256 arm64_ventura: "c2c12504461c084e4b5e57007d6089b7a93a976be08799875e72e5cc88050e76"
    sha256 sonoma:        "74052641f0b6ae249d7910f1a5b08d7a74f2074c0f8c5996d4425d020caddc57"
    sha256 ventura:       "5a8459fa51586034fa392457e581e24536b026ae1fad182253ecfd19a6db1bbf"
    sha256 x86_64_linux:  "72a305001a5d11e454e7deaace1e8a08cd1f3f9914d00145ec34da0871d9a6aa"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
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
