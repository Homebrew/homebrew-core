class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r2083",
      revision: "57df2e179d929532094f4e4dd42ce5395514622b"
  version "r2083"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47cf5a573445ed7c118cb0845334179d1654073ead9c6de4e9b7a7f9c69b535d"
    sha256 cellar: :any,                 arm64_sequoia: "c29c821fff5afa7c5078a61a12b841ccf83b69f9e10648755b3c3d37fbeeed1e"
    sha256 cellar: :any,                 arm64_sonoma:  "1c11d25a63a6f6d3d8be589c622fbb6115f08268d71f3f2bc6e350730978d4bd"
    sha256 cellar: :any,                 sonoma:        "75160c8ac0aa21de83575798cb142b8de59ef744b3f7b94bcff921cb05e29830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f26317e486d5c7857d83a0bfca2b75d443f603003e7be18faec10abe45c2700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e62e644e31513b5e22ce38bf207cf2b6a7afc49bc0b489b047ed18f91aae75e2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "speex"

  on_macos do
    depends_on "libogg"
  end

  def install
    # TODO: Try adding `-DBUILD_SHARED_LIBS=ON` in a future release.
    # Currently failing with requires target "g719_decode" that is not in any export set
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_AUDACIOUS:BOOL=OFF",
                    "-DUSE_CELT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install "build/src/libvgmstream.a" # remove when switching to shared libs
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
