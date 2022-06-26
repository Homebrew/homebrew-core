class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.8.tar.xz"
  sha256 "8eb753ed28bca21f8f56c1a180362aed789229bd62fff58bf8368e9beb59fec4"
  license "GPL-3.0"

  bottle do
    sha256 arm64_monterey: "6b185cadbb07d199bf703390b6e3f0ca33ee7a4c2aa7efa685ebaeee9609323a"
    sha256 arm64_big_sur:  "d83beb6d79c93216c6f33021cd23aeea041d9691d4d5efc0bf43ab15562a3fed"
    sha256 monterey:       "0ba38973389c7e3c37241a4d1730c2686feb51ddfd3f275059af268f44302aff"
    sha256 big_sur:        "93c4e7f7aa503611ad5907b1c702bb89d7fc9a5cfc0866b78378b7bef7a72480"
    sha256 catalina:       "8cd8f1a20368b94f4de10dbfc4c39429cc9d1ad7680dcb160635be49afc598af"
    sha256 mojave:         "9d2c152bff37873f4ac78165161c6f3e338599c3ae55782690f3f9a8a6d8d749"
    sha256 x86_64_linux:   "9addf0b22ab845a8071f0d3dc742c65de4fde1a06a7f41df5cccb2e1c9f6afe2"
  end

  depends_on "gettext" if MacOS.version <= :high_sierra

  keg_only :provided_by_macos

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
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
