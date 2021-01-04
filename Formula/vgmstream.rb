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
    sha256 "214d533c705543d4962d3c9db29f5796d40048c0ff036585ac6ad35f013ad8fa" => :big_sur
    sha256 "f0a3f7bbdccac44d4b9d82c1b423898a625bfcab73da849ccd07b4f0aaf4fcb1" => :arm64_big_sur
    sha256 "4b78bf09f3643d5e2cfc3b88cad0721a4079634970eefa5aa3da56dd0e023e6b" => :catalina
    sha256 "4fc77e961d92b85fb884370c15e57829cbc5dbf1cd9351a2420b8df68ff67f80" => :mojave
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
