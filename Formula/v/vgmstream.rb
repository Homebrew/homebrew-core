class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1896",
      revision: "8e5dbc563a8822886d3d3e6abb4faa2585742cf7"
  version "r1896"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0af31a7a46c5516fc5e1c3bbe867849089789fc628224c6cc3cd39ef87bb77e"
    sha256 cellar: :any,                 arm64_ventura:  "a6d0f22450506ea7a0f506ae7cf8000733fcf6b3484573bcfa57a157740893d0"
    sha256 cellar: :any,                 arm64_monterey: "25de05664a5f8d75cb24381b979ac3f2a7cd204ae0730b8d54147b4a68df2966"
    sha256 cellar: :any,                 sonoma:         "017573c62b35ff8d33e21b24e92cf4e15d6af1dbd03ba03c7ca1a32e6cd019f6"
    sha256 cellar: :any,                 ventura:        "c76243e533cfb1e6cafc618a2a920ac9bd82d438fd60c940fc74dd45d654bfb6"
    sha256 cellar: :any,                 monterey:       "ee29b4ff0ebcab165ecbb0ae8d4e7b26d940dbf1285a3b537a2e0c52a89adccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdc64a6ac20461be95dc805d9f700387fa2405b4ea622b442183a725ad02051d"
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
