class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1843",
      revision: "b158e8122384e174453ef526cd895411f7df80a2"
  version "r1843"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7ff4ac82036983449f91319fe3d867ef9d95655450446913870cc292c401d7b"
    sha256 cellar: :any,                 arm64_monterey: "2fc3b363e3a9222405b8759b157ee3b32e64e2a625351f76b19f824e6e1d4985"
    sha256 cellar: :any,                 arm64_big_sur:  "1f9d679ca8243e1bf604fc72d5f93c15fb42b9059ef0e3afea1a92bc56d220b4"
    sha256 cellar: :any,                 ventura:        "916d701797ecf2535e9c8c0ab60813aaf086d96b0a266e5537bc5fd87760bd0e"
    sha256 cellar: :any,                 monterey:       "44336d348e10ed4ec95579266917c7a6d8f741fcc21958b62c76da7d84f67a09"
    sha256 cellar: :any,                 big_sur:        "610ec7a226c20e6b5ad1e86be0c85fc48a62753e7ec1c631043b38bc06137814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00af66672cd15e7c1c2437623f45594bf8e1bb4d8ed2434cea7d638b1032da39"
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
