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
    sha256 "9b28ea5e9373114cd0553a1da3ee0bcb424c5d99d967ca586e736b201ab9a07f" => :catalina
    sha256 "298a3a24cf365b1600fb8cc4e393181e8f4674b40dfc1e536392d4e14299334f" => :mojave
    sha256 "7ab68532f977a0ff2f0214d585c132ea68a825aad487aa98f43b68f33dfb998e" => :high_sierra
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
