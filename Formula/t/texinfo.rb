class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.0.3.tar.xz"
  sha256 "74b420d09d7f528e84f97aa330f0dd69a98a6053e7a4e01767eed115038807bf"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "c1cb88feb1a8464858f0d65a30ee80623acbe770efa7f391b3fb1e728609404d"
    sha256 arm64_ventura:  "1da60ed030da20fe03388dc0a40271783c5bcc2dfb3d50710ca431f943ef48b1"
    sha256 arm64_monterey: "d36424fb6c196b55f5acc459c393c8950b26cc71d05f15b7d5c7879ac438685b"
    sha256 arm64_big_sur:  "f5af81647753a8f2e1f5882a7ced2d5c6a6c3b55d16a7b21d35f91951bb99eec"
    sha256 sonoma:         "d7f2725cedafc0a11ce472a390c49a5434312f0d36db11eeba163ec99e358bbf"
    sha256 ventura:        "023fb6a619944667e4c1601c260f4b5d12602af3e4a0acdab615426b3856ef66"
    sha256 monterey:       "b6b367a26527726756c1addb017425929b6fc5f344171366c607c842fa53e205"
    sha256 big_sur:        "37d2829b2d1127a25cc761de8d1ae8595720c889e24ba94695dd1786abaef626"
    sha256 x86_64_linux:   "ec964dfd6398ab50dd10181d0fe2df909d6475942f1e1b47b35cffada2aa3236"
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
