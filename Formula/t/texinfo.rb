class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.2.tar.xz"
  sha256 "0329d7788fbef113fa82cb80889ca197a344ce0df7646fe000974c5d714363a6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "abfc842bb08fd512dd878e2233ea6d0d3682685dd9d5a03a86c6c8d170ca104e"
    sha256 arm64_sonoma:  "948d36004ea61e34f1b27d04d4b56c5b1e2cf7bc28861c89fa9cd7c3c87cbdb5"
    sha256 arm64_ventura: "71ed6d2d1b181f10f9fabac5935ff3956d7b63f670e652465b601c2929a19cc2"
    sha256 sequoia:       "bb81887583e785c41b1f6e9812f62f04a304f7d655dad3139d82077f2e61b64d"
    sha256 sonoma:        "4bc4f8a0d5ed88dbee2565088997164573ca8c2e7f229030b2035ba8905172a2"
    sha256 ventura:       "a8e566d23516d94e0f573b648122c74c317c7eea8d16acf55645e5347759c363"
    sha256 arm64_linux:   "f749de410013d9fe866ac0dd634ed6e8d9f462f9979d341f2d9fa727bb1790ee"
    sha256 x86_64_linux:  "46fdddc6b9297240790546b7f1405a7ea103a7c652c74c05cc1bef6b88f320f1"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_system :linux, macos: :high_sierra_or_older do
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
