class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream.git",
      tag:      "r1050-3312-g70d20924",
      revision: "70d20924341e1df3e4f76b4c4a6e414981950f8e"
  version "r1050-3312-g70d20924"
  license "ISC"
  revision 1
  version_scheme 1
  head "https://github.com/losnoco/vgmstream.git"

  bottle do
    cellar :any
    sha256 "22245cda49c47f9e6fcace0938586ec6e7fc7e3b3fb3db5f81ae9d90ecfb4bc8" => :catalina
    sha256 "07f009ac554a703974bf58f519b10f7c332ec7bb56dcdd014072ac58b9638d17" => :mojave
    sha256 "b23065495cadef6eaa2706db779a1f71c8ebc6e6c5af6b53779643dbd4201b90" => :high_sierra
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
