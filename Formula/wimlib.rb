class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.10.0.tar.gz"
  sha256 "989b1b02f246c480dec10469374f4235d15a3d5e5ae054452405305af5007f55"

  bottle do
    cellar :any
    sha256 "820662984db7e93d3a437a1e9a04a4dc52d66ca12caef609a51438e636477348" => :sierra
    sha256 "01953339d96184ffadd03080f40d71238f106d820965ddf8147d412fb3b711d5" => :el_capitan
    sha256 "1708e5941ec5985f5575f41da85893ba05b898dfbb562eee1433163225ec783f" => :yosemite
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
