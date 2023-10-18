class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1879",
      revision: "aa1db48b3687eae5194e3f9e879fa93a13b4354c"
  version "r1879"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5814aa963c9f3037df2d27c32207956f6d8b640027a407869293cb13e21916d1"
    sha256 cellar: :any,                 arm64_ventura:  "4aa3c9f295b7f8d3e210943ed135a693e3609feab6cf355ffc55ca391cbcdc55"
    sha256 cellar: :any,                 arm64_monterey: "e1748bc60ae2958a9bb8c7506146f28cdf0512be9e90dd4c1a3ceae8196a1d1c"
    sha256 cellar: :any,                 arm64_big_sur:  "f8e66b64d684d0aa6a479b4fd97b9e9ac1cf7ceb8c8e6360c7a9b182226f11d8"
    sha256 cellar: :any,                 sonoma:         "4bc42712694358953d718d2fe6ca63d64a085d92160911141a03ef6f7b84ac8c"
    sha256 cellar: :any,                 ventura:        "a74d9e4d5346d1795b5f2eec6a401f5f0491b474b1ba591bc26ed0cfba33af34"
    sha256 cellar: :any,                 monterey:       "e50271eb01c73d554a1ddd71c1d1e5906f54dba27215ba97e9d46d89fa88d6b8"
    sha256 cellar: :any,                 big_sur:        "1ae138490832fd2c8f8cc6af582b72b7396ee776ab07f718ad3d221eb5d79671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a284f2fc9b4e3790d8e6d27f62b103b47b2b572ee5ade98382c4ef9a462877"
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
