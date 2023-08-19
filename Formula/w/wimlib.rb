class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.14.1.tar.gz"
  sha256 "494a15375616f2e0e9ab050245c3dc3286def21ac2002dc064bcc2b187636f42"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "841882a76e18e4731cfba4592d16d35eb6173063bac3a5d1e2cece5d1a4b5ca1"
    sha256 cellar: :any,                 arm64_monterey: "bd79bb9e7b6e4f6721817a6c8c33fe9563fa30b5b0650fd1feaf9e1477809cd2"
    sha256 cellar: :any,                 arm64_big_sur:  "84f6e147e074c2d478cedbfc4dd9c706e27fc0a43b7ff45b71b7dc4437aa9e69"
    sha256 cellar: :any,                 ventura:        "73395f19e288ca45703bf504ce6721400dd8caf1c5501ebf986c51010e0b4bcb"
    sha256 cellar: :any,                 monterey:       "735d1e54e2537931c3d62660a50abdc285e05f097be755401845dec4eaa703dd"
    sha256 cellar: :any,                 big_sur:        "803288085554fe3fee7766363ba5299708b558585a83f3da18a75c28f306a496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a73c1255e395c7e073ad3192a2552a9738c7ac353d1b130d57a347a1abb356d"
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
