class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.0.3.tar.xz"
  sha256 "74b420d09d7f528e84f97aa330f0dd69a98a6053e7a4e01767eed115038807bf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "203015ceba1fbf1093a5c011e19fbabe6b1dca05ad045e19758e11c6a7e9877c"
    sha256 arm64_monterey: "00989e546b03f7c1166d8fec31c138216d73ef736e30a89769dae381f8d05f45"
    sha256 arm64_big_sur:  "484f330054be1bbc8ff6d06a497d48e765f95eec7937dfb3658b8b3d86ac21d7"
    sha256 ventura:        "c94c964e9df885f6782b2d6e8abbc6ff6b2ec7a9106fb07c706294422226dbdf"
    sha256 monterey:       "b31a476410d5171a4424e3423f788f9e1438b7c2d1d79761562221b44a449c14"
    sha256 big_sur:        "1596b0ef4f2e713712d39c704688b5138ca68c4f8000be1866903f88859eb610"
    sha256 x86_64_linux:   "fcf98f2adea8e5d4347516345023398105476a73a87ebd47015c9030f08d6ea9"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # texinfo has been removed from macOS Ventura.
  on_monterey :or_older do
    keg_only :provided_by_macos
  end

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
