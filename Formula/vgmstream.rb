class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1667",
      revision: "6b84f258e4238edd627e24ec8460a7040613d054"
  version "r1667"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "800dc6d132b005b66d25368be52902432bc78a10a7f5ffb158172da48c5fb72a"
    sha256                               arm64_big_sur:  "f344401ea028c6fced781b98573acc97648380cbb3da37fccb614543528d58b3"
    sha256 cellar: :any,                 monterey:       "2ac39455720eca117a7a89736f54cc37764a511376b9cc2bb368dc37a152f7cb"
    sha256                               big_sur:        "a8b9e590e143c8a5820562376a4d8d6455b4aa3719d69134182ccdbe6e2bc940"
    sha256                               catalina:       "ea5a421a93602621a8bf2a62b2eca9affa50790f16d7153bd3f901ef3edd9d9a"
    sha256                               mojave:         "1641ceee1b1849446b3aa2c1ccd07241c1641c9546fff3f785ae5f842b695fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198d6a243a89c0019a1beafbe060c5e8ac361af28eb6e3d396bc5d8ea71af7a5"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    system "cmake", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args, "."
    system "cmake", "--build", ".", "--config", "Release", "--target", "vgmstream_cli", "vgmstream123"
    bin.install "cli/vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
