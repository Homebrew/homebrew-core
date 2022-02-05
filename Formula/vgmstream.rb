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
    sha256 cellar: :any,                 arm64_monterey: "657854dafa6263213d881e2686e838eee4ee1556d5da97706b15db67e1b16bfc"
    sha256 cellar: :any,                 arm64_big_sur:  "1da9bdf68de35520d505dbc59153df161db4e967e2e610a0d5214ee9bfec30f9"
    sha256 cellar: :any,                 monterey:       "f0c52e047a2de316fb3bd9ed331339bcbe826b4e5884dccfc563ac53ad75fae3"
    sha256 cellar: :any,                 big_sur:        "8645bf02e96c0a5e4bc52a51b355af86d7362f60413ed388f14a80ac6c6082fc"
    sha256 cellar: :any,                 catalina:       "d96550fc66015250ef8a2fe7a3864c7e688a0b912a66fc306d0997edbfecd5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb21895ea0256c867a24bc300cc5bc254c2e769e4e74a4cb2766ae9f5662fe57"
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
    ENV["LIBRARY_PATH"] = "#{HOMEBREW_PREFIX}/lib"
    Dir.mkdir("build")
    Dir.chdir("build") do
      system "cmake", "-DBUILD_AUDACIOUS:BOOL=OFF", ".."
      system "make"
      bin.install "cli/vgmstream-cli"
      bin.install "cli/vgmstream123"
      lib.install "src/libvgmstream.a"
    end
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
