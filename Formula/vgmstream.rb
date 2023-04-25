class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1831",
      revision: "9f99e742df8115297cc265244f451e769a3ab23b"
  version "r1831"
  license "ISC"
  revision 1
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1134ccec2b0c677468e7ab8f32dbcbd465f488d6a066d9d294d5f47862ea9f9a"
    sha256 cellar: :any,                 arm64_monterey: "d634c02ad2fd6bc1c75f28f087c22ac1178e7868e2b6baac2233d17b5d1081aa"
    sha256 cellar: :any,                 arm64_big_sur:  "31409a13ad6259e15d5f247ea4e88b1bceca299f1b7d510458c144c3acb7e90c"
    sha256 cellar: :any,                 ventura:        "c81414a5b980145f64806a627c92df9426f7f9cb697b3844b02e61fd75631a76"
    sha256 cellar: :any,                 monterey:       "3404ff129a2abc8938677a448f2b722450850c2a455e2e699eb7627c50a2c9b8"
    sha256 cellar: :any,                 big_sur:        "529ed4ee62450fcf6e73a4f6cad50ef42a3485013f1796ceff422ebe07efa1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74394f04a07dfce4327609b3a65794601ca4eb7d710f5fdb3e395500a523f538"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", "-DUSE_CELT=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
