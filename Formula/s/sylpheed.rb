class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  revision 5

  livecheck do
    url "https://sylpheed.sraoss.jp/en/download.html"
    regex(%r{stable.*?href=.*?/sylpheed[._-]v?(\d+(?:\.\d+)+)\.t}im)
  end

  bottle do
    sha256 arm64_ventura:  "bb7261752ea2aa71d885be5958619a4c29ce7695c9e1283ef20d511e5cf72612"
    sha256 arm64_monterey: "8a86432333e80c75bf6bc4130c3a025147bd24537db18999c648cb0d1c68db8e"
    sha256 arm64_big_sur:  "c592c4608ad89aaba66c8e5e4616f82a8618816074a577d8f804ade18a96823b"
    sha256 ventura:        "7727583d3d171cc0f9ad91a06f8b8b132243adf1abb99ff75177b30d2ebe4fc9"
    sha256 monterey:       "858ccb14e9acb6829826f318c907bc591a16b323af88f0d6d44ad064e2b4fda3"
    sha256 big_sur:        "73b567343fcab79f4ce085937e4a4aaf34045299927aa6ec71fe2e8d8ba38176"
    sha256 x86_64_linux:   "2473c806a8960f5b3b190e4836bde47bac4e7276463310b6c3e5d6cc090442bc"
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl@3"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end

  test do
    system "#{bin}/sylpheed", "--version"
  end
end
