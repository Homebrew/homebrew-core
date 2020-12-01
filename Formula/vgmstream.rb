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
    url "https://github.com/losnoco/vgmstream/releases/latest"
    regex(%r{href=.*?/tag/([^"' >]+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "4b3e15c64a21031f2c48fafb4cdddb1525bcf8e3f28301cc67fd489b5808b115" => :big_sur
    sha256 "9d606f0b0e89d554ffcf3f1b83d38274fd83d9141ccff3cfad0b49e26d8df8ad" => :catalina
    sha256 "eff6d36e01d617fb43cd05f8fc62829d3f49eb4fef4c7039e3c2e875ff124a38" => :mojave
    sha256 "4b2865fda21b44d92cb2fa13b1c179a962c5ddacaac8b1089bdb5b3294de5f09" => :high_sierra
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
