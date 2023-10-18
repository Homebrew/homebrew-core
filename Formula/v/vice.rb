class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.7.1.tar.gz"
  sha256 "7e3811e6024db0698bfbc321bb324572446b8853d01b4073f09865957b0cab98"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "6ff7a6caca0e75485180870115086cff4b4239f945d569900d1c1a13f95c950b"
    sha256 arm64_ventura:  "d0bf3eb28be9043f9116bed994770b9ddbcbda019f817d9f66d35f209baba8cd"
    sha256 arm64_monterey: "90ac62deeed56227098a874eee92465bf5af63d87da03047e0d3a05fe951d46f"
    sha256 arm64_big_sur:  "02279db7f16355ccfedda4ec76e9286d4062507c5bfb4d66e20d7fea13b9ce03"
    sha256 sonoma:         "a65a9ee0f675497ba24dc31d02d4c318558c24f1b4e4140128031142ff472f57"
    sha256 ventura:        "faa7d0090d54fc2deff55e8142b67ccf2549955884b414b9bc3d21c9eec4feb2"
    sha256 monterey:       "83eeb86d3252e8459bb677998a2ad2c6c78eec3d0524cea06585c1ff0120bfcc"
    sha256 big_sur:        "178230a6fa6f45cf9961387f61be1d17c4496dc45c87c578fb524ad64fc55128"
    sha256 x86_64_linux:   "387e1bcbcd567f98141f0789672f353059b0bf4f82226ee9802a016294494721"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg@4"
  depends_on "flac"
  depends_on "giflib"
  depends_on "glew"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-arch",
                          "--disable-pdf-docs",
                          "--enable-native-gtk3ui",
                          "--enable-midi",
                          "--enable-lame",
                          "--enable-external-ffmpeg",
                          "--enable-ethernet",
                          "--enable-cpuhistory",
                          "--with-flac",
                          "--with-vorbis",
                          "--with-gif",
                          "--with-jpeg",
                          "--with-png"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
    assert_match "Initializing chip model", output
  end
end
