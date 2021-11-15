class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.2.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/vorbis/vorbis-tools-1.4.2.tar.gz"
  sha256 "db7774ec2bf2c939b139452183669be84fda5774d6400fc57fde37f77624f0b0"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(/href=.*?vorbis-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "84a6be2cfa26af111e5e557792030f954ee027cb8375fdc8bcf4ab219b21668e"
    sha256 cellar: :any,                 arm64_big_sur:  "04a17ea863d62a4ea5839e6a2c2a86314d06ed6d13883a62b19745994d745317"
    sha256 cellar: :any,                 monterey:       "ea85c845fa0f2ef26128624c219fc748448ca45aaf4c1998dc62943b7d089624"
    sha256 cellar: :any,                 big_sur:        "96ba6cde73391d6a892e9bf2dc858264450481fd82abf7b5b18d51e50f925337"
    sha256 cellar: :any,                 catalina:       "b01d184e0950457c156be75a93e58f33d3e68fc1c563d11c3d4201bd91835f1e"
    sha256 cellar: :any,                 mojave:         "a9564d93b704d270a94dc5831f20a1033a18f4ad8f7c90270eeeb1c65abcd578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6e13cfa641da45da07d912c1b6dcacf9e3603ea2152266605ad212188183259"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"

  uses_from_macos "curl"

  def install
    system "./configure", *std_configure_args, "--disable-nls"
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_predicate testpath/"test.ogg", :exist?
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end
