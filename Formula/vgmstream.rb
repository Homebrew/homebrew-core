class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream.git",
      tag:      "r1050-3448-g77cc431b",
      revision: "77cc431be77846f95eccca49170878434935622f"
  version "r1050-3448-g77cc431b"
  license "ISC"
  revision 2
  version_scheme 1
  head "https://github.com/losnoco/vgmstream.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/([^"' >]+)["' >]}i)
  end

  bottle do
    sha256 "a8b9e590e143c8a5820562376a4d8d6455b4aa3719d69134182ccdbe6e2bc940" => :big_sur
    sha256 "f344401ea028c6fced781b98573acc97648380cbb3da37fccb614543528d58b3" => :arm64_big_sur
    sha256 "ea5a421a93602621a8bf2a62b2eca9affa50790f16d7153bd3f901ef3edd9d9a" => :catalina
    sha256 "1641ceee1b1849446b3aa2c1ccd07241c1641c9546fff3f785ae5f842b695fcc" => :mojave
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
