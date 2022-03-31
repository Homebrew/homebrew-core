class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.0/qmmp-2.0.3.tar.bz2"
  sha256 "a0c22071bedfcc44deb37428faeeecafb095b7a0ce28ade8907adb300453542e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "1671f58d72794803f7f362138bcaface7e2217a83cd066df90de9385c35cf21d"
    sha256 arm64_big_sur:  "3a50839939cbf8eec8628f179761165ed7327f5369f6bac36a640a85ea543de8"
    sha256 monterey:       "e1a35c6f863bb97ba1ab84d3022ebe8d02e1fff5ca84bd0af45ef52d0194e832"
    sha256 big_sur:        "5ba38b280d3a4509d28ac70198764c90940608a11b72e5742251d925430830f9"
    sha256 catalina:       "66e601feb0678c707bb4bc59131443a3fed4cf0992667e282591ac672e6a2d23"
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

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.0/qmmp-plugin-pack-2.0.1.tar.bz2"
    sha256 "73f0d5c62b518eb1843546c8440f528a5de6795f1f4c3740f28b8ed0d4c3dbca"
  end

  def install
    cmake_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
      system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system bin/"qmmp", "--version"
  end
end
