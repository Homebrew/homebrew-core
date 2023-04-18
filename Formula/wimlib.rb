class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.13.6.tar.gz"
  sha256 "0a0f9c1c0d3a2a76645535aeb0f62e03fc55914ca65f3a4d5599bb8b0260dbd9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://wimlib.net/downloads/"
    regex(/href=.*?wimlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "9c9fa0796708c4abda9a4f319fea21949fa087bfd55fef5a3afb85810540e462"
    sha256                               arm64_monterey: "511b7f7dd4a2f604c79b77e4730df771a72c0d42ff9a0d75016aadef18bfea02"
    sha256                               arm64_big_sur:  "8987877ff4c56d34096c3cb7b34447b55296ee443205b535edbb1e304642acd3"
    sha256 cellar: :any,                 ventura:        "bf7b4fdb7aa71fcaa04efe8dcd716d969c418a1544f763b0542045938e7b6c09"
    sha256 cellar: :any,                 monterey:       "2eaa7b1ad62ecee16880f8e12bbce465b2ffaaa43e446758f19390daf00d1450"
    sha256 cellar: :any,                 big_sur:        "da2511a595e4c203f2f2ea20f543011acbe7a95cbdc5372206616d7589ea17d8"
    sha256 cellar: :any,                 catalina:       "a59ad26171c1affffdc53d90a63802ffe973d74b593ae85c582f10c940767b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befcc8cb24bcb7b41af8e8d85cb0e0f14b23abc713ca5004c8a5c9d52da14dca"
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
