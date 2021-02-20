class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.13.3.tar.gz"
  sha256 "8a0741d07d9314735b040cea6168f6daf1ac1c72d350d703f286b118135dfa7e"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256               arm64_big_sur: "a2ff0fc910f2cd3925474e7f7ea700d1f4dd9df724df1c634a47e733752393cf"
    sha256 cellar: :any, big_sur:       "2e0597a2e987116627df9c6d3a7cb7aed0bd8ed507f5f13b530df685a9e0fe9b"
    sha256 cellar: :any, catalina:      "51512426e7836eb9a204f036993ef023bf260129fadde73761c1ff487cfa2518"
    sha256 cellar: :any, mojave:        "479dd4c3bb4eade0c59f92c776aab3bcceba107f6ed7e65ab1ba6006dce1823e"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

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
    size = nil
    on_macos do
      size = "1m"
    end
    on_linux do
      size = "1M"
    end
    system "dd", "if=/dev/random", "of=foo/bar", "bs=#{size}", "count=1"
    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system "#{bin}/wimcapture", "foo", "bar.wim"
    assert_predicate testpath/"bar.wim", :exist?

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end
