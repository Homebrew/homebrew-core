class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.12.0.tar.gz"
  sha256 "852cf59d682a91974f715f09fa98cab621b740226adcfea7a42360be0f86464f"

  bottle do
    cellar :any
    sha256 "6d630077f6f2b47bd1ace64838f66aa80ffebc4a5f8df84e6e3031b63479c1a8" => :sierra
    sha256 "b4c6d36bd9b3cb010c992cede61057cd253a18c69e7796f1d994db70f765f9ca" => :el_capitan
    sha256 "68fac17c5112e09623c1ebdc5392ec96fb595238f83118760c1be63e626924ec" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "homebrew/fuse/ntfs-3g" => :optional
  depends_on "openssl"

  def install
    # fuse requires librt, unavailable on OSX
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --without-fuse
      --prefix=#{prefix}
    ]

    args << "--without-ntfs-3g" if build.without? "ntfs-3g"

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
    assert File.exist?("bar.wim")

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end
