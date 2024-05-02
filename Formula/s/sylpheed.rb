class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  revision 6

  livecheck do
    url "https://sylpheed.sraoss.jp/en/download.html"
    regex(%r{stable.*?href=.*?/sylpheed[._-]v?(\d+(?:\.\d+)+)\.t}im)
  end

  bottle do
    sha256 arm64_sonoma:   "5d721116ce6251186a708674cee20e33b3401bdeda3717ac4bce42b88cad326d"
    sha256 arm64_ventura:  "bf0debe030355889d321d9067c9333c15f3d121b1db0d649677331feb0c2d86d"
    sha256 arm64_monterey: "ac939d1e4db50c04b4ed1f885e43372bdf6a899161c4ff4e72660d53339e31cb"
    sha256 sonoma:         "05053c3a4b44125484f4cd50e517aea97c49ae0a4c0ed0c43c3707ecc71097dd"
    sha256 ventura:        "3cd656efec4737b8c7b951d8dcf43087c6e4b6ca80ad4a39d4f5cc8aca6c8e0a"
    sha256 monterey:       "2f6e29e61c7b94044e37d994e4e81d8b6af1cb7bba6927bbab5e7dbf4fec2cd3"
    sha256 x86_64_linux:   "7f6c1fda4cf4cd10ad6d862e0588c6f89b20a2471efeb562d74c09532a60ca41"
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
