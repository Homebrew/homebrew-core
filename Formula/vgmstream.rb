class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream.git",
      tag:      "r1050-3448-g77cc431b",
      revision: "77cc431be77846f95eccca49170878434935622f"
  version "r1050-3448-g77cc431b"
  license "ISC"
  version_scheme 1
  head "https://github.com/losnoco/vgmstream.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/([^"' >]+)["' >]}i)
  end

  bottle do
    sha256 "4a16ce76fe0d5ec2d54854dbfca2af23382c5d82aa5849a2b43cd6343990a9cd" => :big_sur
    sha256 "46743ef7b4c70323b20958a96956b20e706eec25f642867bca34afd12a50944f" => :catalina
    sha256 "8295377a0ee9e671332a0b4861d5f010eb0c98ecff11f83fed8e818451034b31" => :mojave
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
