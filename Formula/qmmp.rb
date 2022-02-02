class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.0/qmmp-2.0.3.tar.bz2"
  sha256 "a0c22071bedfcc44deb37428faeeecafb095b7a0ce28ade8907adb300453542e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:  "c0bcbb232e8d57f4e19c63a909e338df2e26f496b4321fa43906df7ec7902195"
    sha256 catalina: "d6ddd71b112e1e83142b172c509f9c63dff093c2cca63e452b7c8d4f37304279"
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
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.0/qmmp-plugin-pack-2.0.1.tar.bz2"
    sha256 "73f0d5c62b518eb1843546c8440f528a5de6795f1f4c3740f28b8ed0d4c3dbca"
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
