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
    sha256                               arm64_monterey: "40559e92c437d4118aaa00083d30f725487fb5ee81855de4b861bfac3eeef9e2"
    sha256                               arm64_big_sur:  "00339068d980da7bf1aecae841ed84cd9826744cd3146260d36b88b2aa1ad739"
    sha256 cellar: :any,                 monterey:       "5d0795512b9d00a7176ca12daf4ae066abe9cbdfa18b069c49dc2594aba6a711"
    sha256 cellar: :any,                 big_sur:        "c67102fbaa4bc9d44cac47140bedbbbe4230e11a97c41044acdf46366566edba"
    sha256 cellar: :any,                 catalina:       "e0555889517aed6ec2163c0c79e1d3c76c48768a1544193905b719dec74d62fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb62fa15600f1d34ab960a2744adc21e502320fe88b3da6a78b57d87c227ba08"
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
