class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.1.tar.xz"
  sha256 "deeec9f19f159e046fdf8ad22231981806dac332cc372f1c763504ad82b30953"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "6ee1d5c2e64d80dcc8da4639d55d6c7a907550efd3ecfb4757f719f875e3df1b"
    sha256 arm64_ventura:  "7e412d561339fa51dd78af8d0f6ec0c6a56cd7ce907fb7b6c417a6c6f1eaadba"
    sha256 arm64_monterey: "a106b57dcf2dbcd8e3c4ca4d25a48c93a8dec9ba8ba1940082d70c0220846342"
    sha256 sonoma:         "65cf063c13da2f386da45a9161a8b1a8f88191273c66205f3c3267cc31857510"
    sha256 ventura:        "971990897e2ec8424366cd1a0715972a58550890498b27a138f9d588115660fb"
    sha256 monterey:       "34c5c6ada9cdd5cc4a1f84e16aa0990ddb3f3b98a9ac5890845e8ae2f327111e"
    sha256 x86_64_linux:   "0e19faddba0095b10438272020bc3add109e39523683bc8705e1e0f1a9b2ca25"
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
    info_dir.dirname.glob("*.info") do |f|
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
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match "Hello World!", File.read("test.info")
  end
end
