class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ee631ed7b16976bdb280c5538f9ff73de447cf98f88793284f4cf3952c634cc0" => :high_sierra
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
