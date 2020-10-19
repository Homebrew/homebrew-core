class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream.git",
      tag:      "r1050-3312-g70d20924",
      revision: "70d20924341e1df3e4f76b4c4a6e414981950f8e"
  version "r1050-3312-g70d20924"
  license "ISC"
  version_scheme 1
  head "https://github.com/losnoco/vgmstream.git"

  bottle do
    cellar :any
    sha256 "74b726aca9e8a085ff1d5f4afe6f892f3620d2cb229c86276451fcb25e993a11" => :catalina
    sha256 "b233a6c088526b989be281b44ff467aec792ff8cfc69afed7329f60f82b51eb5" => :mojave
    sha256 "ffa46eab45d850eaa18f0f0e280a9e387d0332b89935e4a6cdc5f1e5455fd228" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
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
