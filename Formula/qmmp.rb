class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.1/qmmp-2.1.0.tar.bz2"
  sha256 "ac7b5981e371dc58759d5efd2babb42e377ecc5260ba3e57ac6dbf0897570ddc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b2a56237442cfee1d7e1517b928be7817880d06b6f743f18c981887e6a863456"
    sha256 arm64_big_sur:  "0744e49b9ad162030d4ff0fb680893ec978be00a36266b5251959d36ff959500"
    sha256 monterey:       "b08c25679f1195632de44cace21a16512f619c735eb1dc24270f22af0b445507"
    sha256 big_sur:        "a2a652ec27d8e3092069ff7febf23e2c36b17085ff0a95b04da5584be9b1ab65"
    sha256 catalina:       "e5aa4ce020a7abff091232228065c2dbb61db60579d211841d8171f4764693b9"
    sha256 x86_64_linux:   "2b0ebca845a83fb60afe6c1ad4d4613dad1c9bc5a676c30072a0a6ff6ffc953e"
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
  depends_on "opus"
  depends_on "opusfile"
  depends_on "projectm"
  depends_on "pulseaudio"
  depends_on "qt"
  depends_on "taglib"
  depends_on "wavpack"
  depends_on "wildmidi"

  uses_from_macos "curl"

  on_macos do
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.1/qmmp-plugin-pack-2.1.0.tar.bz2"
    sha256 "25692f5fc9f608d9b194697dae76d16408c98707758fb1d77ca633ba78eee917"
  end

  def install
    cmake_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DUSE_SKINNED=ON
      -DUSE_ENCA=ON
      -DUSE_QMMP_DIALOG=ON
    ]
    if OS.mac?
      cmake_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
    end

    system "cmake", "-S", ".", *cmake_args
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
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    system bin/"qmmp", "--version"
  end
end
