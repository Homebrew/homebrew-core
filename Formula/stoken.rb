class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.91.tar.gz"
  sha256 "419ed84000bc455ef77c78e3ebfd4c6fd2d932384563989f864becbafd51bcf4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b818f8cfd4afba73a8a123dfa2dc7dc7b2c066c9dce164ab853a5a5a8b5b31de" => :sierra
    sha256 "a14908e16d1d104e46f9f606fd5a79514b08ad982a7cec5370ebad5072309b4a" => :el_capitan
  end

  depends_on "gtk+3" => :optional
  if build.with? "gtk+3"
    depends_on "adwaita-icon-theme"
    depends_on "hicolor-icon-theme"
  end
  depends_on "pkg-config" => :build
  depends_on "nettle"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/stoken", "show", "--random"
  end
end
