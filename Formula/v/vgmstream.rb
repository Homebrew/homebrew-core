class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  license "ISC"
  revision 1
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  stable do
    url "https://github.com/vgmstream/vgmstream.git",
        tag:      "r2023",
        revision: "f96812ead1560b43ef56d1d388a5f01ed92a8cc0"
    version "r2023"

    # Backport CMake install support
    patch do
      url "https://github.com/vgmstream/vgmstream/commit/e4a00bc710e99c29b6a932ec353d8bc6ba461270.patch?full_index=1"
      sha256 "9ee47e5b35e571a9241bcab6ebe8ae09ecffde72702cacb82b4e93f765813e0b"
    end
  end

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "af03a94c586e2eb92bc60f3d3c93acaf2215a659ec25d31e6c588695d44b1bfb"
    sha256 cellar: :any,                 arm64_sequoia: "4bfc16d7e11604d78e45b14a806816ab697d21913cf0c421a21bf58bd54be1c4"
    sha256 cellar: :any,                 arm64_sonoma:  "ae63cd86273517312f26ed2b044d83a376c907b21d1eb74bd0e5cea844f332c0"
    sha256 cellar: :any,                 arm64_ventura: "8d8296a13a9c4c0eed313d63d2974dedf5f9ac6af6cc28c7f2dc618b7471fc42"
    sha256 cellar: :any,                 sonoma:        "29cabdb26b4cf7cf575668cee96f1c8ac443b57629293004b4236cf92235d3ad"
    sha256 cellar: :any,                 ventura:       "b21b65d7c738ced87097c6934291ed67552556b606e186198dca32d1454d0ff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32ec88b2016eaacec8f1817288fd1d846729dea8df4e374cae07e78822d1de0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3672b0394462a9bd7a250af7f8089ee64430f6c56ad20f93c636b9fe3d2c7968"
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

  # Apply open PR to support FFmpeg 8
  # PR ref: https://github.com/vgmstream/vgmstream/pull/1769
  patch do
    url "https://github.com/vgmstream/vgmstream/commit/3e12a08a248cfb06f776b746238ee6ba38369d02.patch?full_index=1"
    sha256 "4d0eed438f24b0dd8fa217cf261cf8ddb8e7772d63fc51180fe79ddceb6a8914"
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
