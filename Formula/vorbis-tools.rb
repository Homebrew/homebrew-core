class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.2.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/vorbis/vorbis-tools-1.4.2.tar.gz"
  sha256 "db7774ec2bf2c939b139452183669be84fda5774d6400fc57fde37f77624f0b0"
  license all_of: [
    "LGPL-2.0-or-later", # intl/ (libintl)
    "GPL-2.0-or-later", # share/
    "GPL-2.0-only", # oggenc/, vorbiscomment/
  ]
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(/href=.*?vorbis-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0bbda8f387e434f645cfab25de99e28e8331d38eaba4a88ca124994ec2c5f6fd"
    sha256 cellar: :any,                 arm64_big_sur:  "5396b9e517cbb7fb7384e272affcce8b5a9ef263346611dfb068ed34be4988d8"
    sha256 cellar: :any,                 monterey:       "32880efc56baaebc010f2e2b465852c9bad030cf8c4ddfceddb5961c4703872b"
    sha256 cellar: :any,                 big_sur:        "ad1acc242f7976a700261ef8c914cf912a4bcd9970eca8009d949598648a16f6"
    sha256 cellar: :any,                 catalina:       "04f820f7dfc6d2fe964b1e18e564728cbc4feb127b562bd788b80f7d40a23eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b137af1a327bf93e3922244bf03ab2eef1151838483b2e71e1e35c5254d32cc4"
  end

  depends_on "pkg-config" => :build
  # FIXME: This should be `uses_from_macos "curl"`, but linkage with Homebrew curl
  #        is unavoidable because this does `using: :homebrew_curl` above.
  depends_on "curl"
  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"

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
