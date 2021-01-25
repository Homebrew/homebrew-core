class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.2.tar.gz"
  sha256 "db7774ec2bf2c939b139452183669be84fda5774d6400fc57fde37f77624f0b0"

  livecheck do
    url "https://downloads.xiph.org/releases/vorbis/"
    regex(/href=.*?vorbis-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "eabf92d09b16e16586caf87136e246da3acad99e772b763323c4b2dd05aa6d23" => :big_sur
    sha256 "f6c6cc107f9c88f063f506dbf312602c4e9e61c80b5100aa77c6a3c7247eb7ee" => :arm64_big_sur
    sha256 "1d5caa7c22505a85eaa0a67930047b7d17786401b9c3376b67647502d4b056b5" => :catalina
    sha256 "469c4ff8079bd5a47d4aad1d06981660e6968facc25e542e54e505495261d8f1" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"

  uses_from_macos "curl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_predicate testpath/"test.ogg", :exist?
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end
