class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  version "r1702"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  stable do
    url "https://github.com/vgmstream/vgmstream.git",
        tag:      "r1702",
        revision: "a76ac04dcd41f1926a721e626657397bd9656a74"

    # patches for fixing macOS build error, remove them at next release
    patch do
      url "https://github.com/vgmstream/vgmstream/commit/04b5a1f098f348c4c438ada85ee86f5a9abce2ff.patch?full_index=1"
      sha256 "37d5d9567435eda96bf4e51b5abbac1677391e08daf4e50b1d7edc6996772919"
    end
    patch do
      url "https://github.com/vgmstream/vgmstream/commit/f9230158d953dfb0fb14a2a57052a8460a5d43dd.patch?full_index=1"
      sha256 "10ff07d7c6f48275af235d720f279ef62d444c88cde78f2fecaf065e120d134d"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "af643dfc03fec86043c11237e5d37cb2361950cd790996fd9dc5c2e8679993fc"
    sha256 cellar: :any,                 arm64_big_sur:  "ab0f747f8e4d16fe25eb2705bfbfda69bd60b99615d811cf58b13be15d43ed25"
    sha256 cellar: :any,                 monterey:       "ac7fe6850d70179edd15a5f0c791bfcbba90434d5051b85bd86cb34656c93102"
    sha256 cellar: :any,                 big_sur:        "37496780f4f66b8f0abb1da2e94a02535e128b8d3c80308656c6366702f82832"
    sha256 cellar: :any,                 catalina:       "c08665d1213fc63ce37aecd5e9d0fd01383c2c7ddffb3d0460336f690f304092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa68bd410e8c05d727d42614a8d2a394cdb639d5ff3c207ba4faecff55d7341"
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
