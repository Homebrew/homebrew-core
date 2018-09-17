class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.12.0.tar.gz"
  sha256 "852cf59d682a91974f715f09fa98cab621b740226adcfea7a42360be0f86464f"

  bottle do
    cellar :any
    sha256 "90885cd4c036828bdeee29a9f68d2c33e7c80a644599cc0a797a502ec82fefbc" => :mojave
    sha256 "bf98257d6f32313b3a57713ae6b2ad7c3f72ddd5b1e1ed609436fb337ba51d63" => :high_sierra
    sha256 "32a00c25f98932b84ac5304df29eb5f6edea0a2fc3a2b33ee83938e92c488549" => :sierra
    sha256 "6a2b65020b31dbda4499bffbe773e5596dbc130d6f91ee84c9a7c532dd858594" => :el_capitan
    sha256 "c26d19bd6a6994fae60000f329d136c991b6a1172141c6c047792175a2c79439" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    # fuse requires librt, unavailable on OSX
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-fuse
      --without-ntfs-3g
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    # make a directory containing a dummy 1M file
    mkdir("foo")
    system "dd", "if=/dev/random", "of=foo/bar", "bs=1m", "count=1"

    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system "#{bin}/wimcapture", "foo", "bar.wim"
    assert_predicate testpath/"bar.wim", :exist?

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end
