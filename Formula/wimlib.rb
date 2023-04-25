class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.0.tar.gz"
  sha256 "7a5d84ff5a4626ac03de18a7222293f579cd7061b0159d024a9b315aef23ed4c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95e398be941a4eb36e3cec7d96641d4fdeb299eaa46fd2cdc04bc13a1a7a6471"
    sha256 cellar: :any,                 arm64_monterey: "6b638476d0614c319f96ce7413a9c35500e720bf2ec6aa075d11343ca5e059af"
    sha256 cellar: :any,                 arm64_big_sur:  "a3154433054da5a97c7117c3f51dddc99972a9dbd11e33c038942021f5b56971"
    sha256 cellar: :any,                 ventura:        "6244ffd1bb8c4bc3bf6cf09afd506b28534c0492067e3a83554950557ac0de4c"
    sha256 cellar: :any,                 monterey:       "24803c738ba5f6a2441e10781e147620e372d747fa9db916cf6292e344dda356"
    sha256 cellar: :any,                 big_sur:        "9b7a7213ed05e7b2915d8bc037b9225c295cd8eed9927b848112c5c69bf0ef94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b81d33222bc32c874cae8dac2eafdbc6dbb20ce96e8c593806fd4203621adb5"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

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
    size = if OS.mac?
      "1m"
    else
      "1M"
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
