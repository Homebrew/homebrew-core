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
    sha256 "2e20aabc071c0ab510538f393a13d62db0c5206d77c059be32363b67bb4fea69" => :big_sur
    sha256 "afd742c76098123654e4e7a41b94097c3d58b959ee4205a29eb1c5f4793bee62" => :arm64_big_sur
    sha256 "4dcc975143838b793a68e5e02ad14d08836c9cf2e89601af962105ed13b82a99" => :catalina
    sha256 "cf8c8cb2b75f5afdaaf9468967fd04895ef2a0cead7ce14ff403c95f6fd073dd" => :mojave
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
