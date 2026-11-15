class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r2168",
      revision: "d9875b1fff307e4759dfb85e49e3d5e6fb196f7c"
  version "r2168"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2296b09690a0387667869efeb119ff81f7a3d5a9a671afaf4f76a77d91391cd9"
    sha256 cellar: :any, arm64_tahoe:       "2cae5223272efd3168247e4a51d997e48504cce6e6e7e044cb5f8f9e31be1490"
    sha256 cellar: :any, arm64_sequoia:     "ce92928dd88d7614f902cdfdd6940c1bb5e0c61198ecabf2f1fb9505988163de"
    sha256 cellar: :any, arm64_linux:       "3d588f7dabae5d7eef47e49fa7c9523e374f3df665fc0a8a1d462308610a8d67"
    sha256 cellar: :any, x86_64_linux:      "fee5af67a1581ce64a20a000ffa892a007672db3f7ba7cd355987c6119530d23"
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
