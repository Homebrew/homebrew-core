class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.13.1.tar.gz"
  sha256 "47f4bc645c1b6ee15068d406a90bb38aec816354e140291ccb01e536f2cdaf5f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7969f20ce9f26b7435b4242fb241c2527848581469be0cad09a3f5de77b11a05" => :mojave
    sha256 "33a3397f536e339ca4177d3639b55e223040883af9d5afbbb47cc3e9b1bb87e9" => :high_sierra
    sha256 "66a39e7eaa96a26f988a0c6eba0ad614ca449b0bb5688ebd70830f8863da5244" => :sierra
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
