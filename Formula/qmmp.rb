class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.0/qmmp-2.0.0.tar.bz2"
  sha256 "c631d69c8bfcd77746bb94e2fc4cb7186d16cd29598de08d9771a45c212c6519"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:  "144bd80fb2a050a68900c40a44f00fc05fb7addc660e7807e900a129f86b8a89"
    sha256 catalina: "feff3c70d129d608e05e83928031134d9422cfedb52f305617a2c3af62802f19"
    sha256 mojave:   "7001d36b42beb62f494c03d0e15bf5a153712ad9784af50df1e8042b52d682f6"
  end

  depends_on "cmake"      => :build
  depends_on "pkg-config" => :build

  # TODO: on linux: pipewire
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "game-music-emu"
  depends_on "jack"
  depends_on "libarchive"
  depends_on "libbs2b"
  depends_on "libcddb"
  depends_on "libcdio"
  depends_on "libmms"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "libxcb"
  depends_on "libxmp"
  depends_on "mad"
  depends_on "mplayer"
  depends_on "musepack"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "projectm"
  depends_on "pulseaudio"
  depends_on "qt"
  depends_on "taglib"
  depends_on "wavpack"
  depends_on "wildmidi"

  uses_from_macos "curl"

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.0/qmmp-plugin-pack-2.0.0.tar.bz2"
    sha256 "dd10362e42804e604d216a79e9a8b1d4851be0da72d7c6ee0ad9ddb1166f69dc"
  end

  def install
    cmake_args = std_cmake_args + %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DUSE_SKINNED=ON
      -DUSE_ENCA=ON
      -DUSE_QMMP_DIALOG=ON
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup
      -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup

      -S .
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    resource("qmmp-plugin-pack").stage do
      system "cmake", ".", *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system bin/"qmmp", "--version"
  end
end
