class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.13.4.tar.gz"
  sha256 "4b87dd0ad9cc1a58cee5721afebb98011dab549e72f2b55533f315f08b2ede12"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_monterey: "2dffb84fed109312b06893f430b7d5fdf3ad9942ce24602548bed0cfed6de43c"
    sha256                               arm64_big_sur:  "2acbaa6a363897c9c46fd5e058e11c1b234287367d192e31422103c4b467d323"
    sha256 cellar: :any,                 monterey:       "4ceacbc5dec620a653815b2fab67da64c9125626f51fc329367e361aa4346016"
    sha256 cellar: :any,                 big_sur:        "055f311cbc8a3ac7e36978a9ad0c69a6825c6ba78136492765a7c2b3ba3fc84f"
    sha256 cellar: :any,                 catalina:       "1db7b55e58b89d67b1365788c595bd08d13c04c9f7c218d488ec3edd7bdd67a2"
    sha256 cellar: :any,                 mojave:         "a78ad3433ec595db6568099566f9b15d4919a70a462260afc3f89560bbbb4d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a29439ca3356d8f9a6cbd8acf64a9500eb54080c0433e2dd42fea78d6f237817"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
