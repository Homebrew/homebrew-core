class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r2117",
      revision: "71e2361042531fe767fb98300cf8c1ee95e539a0"
  version "r2117"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42efc7d31923a8223997687b4e3b75c51c1bb0060b880b6758197107bacfa8f3"
    sha256 cellar: :any,                 arm64_sequoia: "7666a7296ad12b3457713813428c6922c0217b7cc6871447a4544254cb710592"
    sha256 cellar: :any,                 arm64_sonoma:  "630809d4b97aec569421bb4e9205ecd0b5421ea3f3e277d6c2fa14ef27ad4469"
    sha256 cellar: :any,                 sonoma:        "fe45b64cf96542feae9fef19d43ee18119fce8a1ee03c97c12e72d7313094ed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eda3ceb22f2d299fef87dc9cb28187acf8c9714b12797d7f8f0f9a2bf4dd6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86752c52fe100b1aabac73b698f4e277c318a7898e6c7bb14c3f747762fdc392"
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
