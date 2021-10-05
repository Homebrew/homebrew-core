class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1050-3448-g77cc431b",
      revision: "77cc431be77846f95eccca49170878434935622f"
  version "r1050-3448-g77cc431b"
  license "ISC"
  revision 2
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "f344401ea028c6fced781b98573acc97648380cbb3da37fccb614543528d58b3"
    sha256                               big_sur:       "a8b9e590e143c8a5820562376a4d8d6455b4aa3719d69134182ccdbe6e2bc940"
    sha256                               catalina:      "ea5a421a93602621a8bf2a62b2eca9affa50790f16d7153bd3f901ef3edd9d9a"
    sha256                               mojave:        "1641ceee1b1849446b3aa2c1ccd07241c1641c9546fff3f785ae5f842b695fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "198d6a243a89c0019a1beafbe060c5e8ac361af28eb6e3d396bc5d8ea71af7a5"
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
    bin.install "cli/vgmstream_cli"
    bin.install_symlink "vgmstream_cli" => "vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/liblibvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
