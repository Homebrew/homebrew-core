class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.13.3.tar.gz"
  sha256 "8a0741d07d9314735b040cea6168f6daf1ac1c72d350d703f286b118135dfa7e"
  revision 1

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "614a97547be188f045804df374d629d78f47949b0987327531802839edc25ff9" => :big_sur
    sha256 "cca83d6932d6acad1449a9e55509868e7e403b1b360e1da34ad5d4e1900def87" => :catalina
    sha256 "edeeaa5d20b4612eb24252ef825cec5c4a9c6e36d31f93d8901f6575bffeaeeb" => :mojave
    sha256 "cc317323e8e2a95cf69518cb6257ae2de1bd548b8e76c3c404e057cfc27bdcf6" => :high_sierra
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
    system "dd", "if=/dev/random", "of=foo/bar", "bs=1m", "count=1"

    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system "#{bin}/wimcapture", "foo", "bar.wim"
    assert_predicate testpath/"bar.wim", :exist?

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end
