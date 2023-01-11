class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1810",
      revision: "8b0204f3fce845df91adc68e43669f9b660d7c63"
  version "r1810"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b5843a752472e42d9328df4087de07923eb21aa537574742e434d2505026a97"
    sha256 cellar: :any,                 arm64_monterey: "8e63e83518e1174e109141fa7b9f200b1efed1986d9fdd18ef10721b810db14c"
    sha256 cellar: :any,                 arm64_big_sur:  "bb0ede7d7cdd10921fd8508ffbdbb1dc09b669c6d0b61e1c992a41d6d7330079"
    sha256 cellar: :any,                 ventura:        "2c6a4d0b500ee3bf6f83b19f5142a7217a476d96675593474d1259e93aa00997"
    sha256 cellar: :any,                 monterey:       "10a4c614a6ce5c77d695bc6f2bfc87ffaaab8d07d5eb03985cd3af58de2f6b4e"
    sha256 cellar: :any,                 big_sur:        "763234332e1ea9ffe3e2da2e4ccf3127ac2817040e47134bbd654055d510fcc4"
    sha256 cellar: :any,                 catalina:       "e14bdacae7a9672a0991b8decc17b2843f4d72b357b1e762b8ae0eaad24dd8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1680a96900e3902ac9a4987e9f7aed3847ab42771cdd890f00a1941ca10a6fe5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
