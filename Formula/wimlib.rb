class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.9.2.tar.gz"
  sha256 "067cf78e6083a585d7dffd8ded059ba9584c3d530afcddf40b7219bc9adfd94f"

  bottle do
    cellar :any
    sha256 "fb1013faac37a33803d76dd89dba0b5a41c8c01d79e422f96280bac84d62bbb8" => :sierra
    sha256 "55a8906f75678ab02804d5bc598040562a4dfa40f70dc5150c713474d5f4c881" => :el_capitan
    sha256 "1659a5b25636208c214997519683b60acbf88b393cef580f077675f58eadb73f" => :yosemite
    sha256 "db80b488c50b8bb5b4729c51409f2d83c0126f2cc60119f2ce415aedfe7d0e91" => :mavericks
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
