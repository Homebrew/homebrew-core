class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1917",
      revision: "3ac217fad9989079d4fe92453b6f39c13f3261a0"
  version "r1917"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7eb12c4a211d5ef8d6fed9103227341396a2f598cb58ce4f7165f4a8c0a2d501"
    sha256 cellar: :any,                 arm64_ventura:  "68a003f21b58d8a7f6da0db64e8140ca5119231e9b70f4e45d034e1387cd7eb3"
    sha256 cellar: :any,                 arm64_monterey: "a8132501a47104fba1897e0344c11976f56631ae5b09bef0112f386e73aac1a5"
    sha256 cellar: :any,                 sonoma:         "48690edae6edab3d22db33fb9ff00ee185850a5f902d600d93e21b2a363613d9"
    sha256 cellar: :any,                 ventura:        "9627aa32e5f63557251a4639c52d971e69cb19b403521f89f8f2017ddbf92d4a"
    sha256 cellar: :any,                 monterey:       "a30147d3579923528c7a05fe596a281a12d61e354bb3247ece4edff24e9e08cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6ef5dff01b656ce05e72b58b22c4951f43e09ae2f33d5c53249ee05104bd67a"
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
