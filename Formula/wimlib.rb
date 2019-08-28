class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.13.1.tar.gz"
  sha256 "47f4bc645c1b6ee15068d406a90bb38aec816354e140291ccb01e536f2cdaf5f"

  bottle do
    cellar :any
    sha256 "7666d8a3fff2f085ebc38c8dd1df247bb858627c2045c28f6228498f898ccac4" => :mojave
    sha256 "5dd208d387537a4b1688fb350cd94046d467ce4e00e41f4545ff1df665cb2ca4" => :high_sierra
    sha256 "616767314d918a7e566c2c663bdb4d814baa8dde884e193b61932766bee5c150" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
