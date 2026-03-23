class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/vorbis-tools-1.4.3.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/vorbis/vorbis-tools-1.4.3.tar.gz"
  sha256 "a1fe3ddc6777bdcebf6b797e7edfe0437954b24756ffcc8c6b816b63e0460dde"
  license all_of: [
    "LGPL-2.0-or-later", # intl/ (libintl)
    "GPL-2.0-or-later", # share/
    "GPL-2.0-only", # oggenc/, vorbiscomment/
  ]

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)vorbis-tools[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba951810e66deef3e95f0221893c66ba61714a590200dea95af16590595aba94"
    sha256 cellar: :any,                 arm64_sequoia: "90772f684b42063eeed55dfe4e3474007b1ff9f6f83114ac04f6b392984a39bd"
    sha256 cellar: :any,                 arm64_sonoma:  "5b2a530e21e74a68a228e4a7c4a4adbd8e7723e6dbbd627a44001f8b90673002"
    sha256 cellar: :any,                 arm64_ventura: "fa047db81ba9212b7ee38570602086bed423456007c59eb2e9f5c2e883b412a5"
    sha256 cellar: :any,                 sonoma:        "c06c90a0f929edb01a55843de22d3d7c81c97ca23c3baf27ada5ef9ec0793872"
    sha256 cellar: :any,                 ventura:       "dfd8e9fe627b76127cd956477d35f043d6f3cd1a0a00830f1e7bd33ae8cc5ca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "817d166c647bc6e97d1a462c2d350c011dc4c298d09e77aed7fd939b90303a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b66ff3ed8885d6b8c6ba8aff13bdfd348907376039d1c9d218daec795886df6f"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"

  uses_from_macos "curl"

  on_monterey :or_newer do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if OS.mac? && (MacOS.version >= :monterey)
      # Workaround for Xcode 14 ld.
      system "autoreconf", "--force", "--install", "--verbose"
    end

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args, "--disable-nls", "--without-speex"
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_path_exists testpath/"test.ogg"
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end
