class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-4.2.3.tar.gz"
  sha256 "78c781ce2c3783b85d894e29005b7e98fc246b33f94616047de3bb4d11d4d823"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?wandio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4063de66b208d6aeae0276d957b51ed674e89289e959a21153bbdcd76cf96468"
    sha256 cellar: :any,                 arm64_big_sur:  "561c437e4a6521dca50fddd9a0099be26e0b4382c208866514a9fd921d10b76e"
    sha256 cellar: :any,                 monterey:       "0862761eff6d46c4f9e829d0a39d6e573bfb1a0ae6156ab3012d2b70d4635815"
    sha256 cellar: :any,                 big_sur:        "5ebf117a69a7e0fdb352d3b9ec31d1c58c775f9554ae1c8aad536d791a001e52"
    sha256 cellar: :any,                 catalina:       "2315e97da8b41e130ce44790da94a692b7125b4feede7d6becec880b68178b21"
    sha256 cellar: :any,                 mojave:         "fe2c352b368e3e440f5ddfdbce45002c849a7446d056dfe4f542a28cd06c1aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee249f1f58477936bc3e6b87cf9a41eed6f28dac996a5482b13e6f9f63aac0ff"
  end

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz" # For LZMA
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz",
      test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_predicate testpath/"test.gz", :exist?
  end
end
