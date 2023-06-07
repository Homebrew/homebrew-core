class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.5.0/SVT-AV1-v1.5.0.tar.bz2"
  sha256 "a649b071906fb840df19fb0e2ec97c04fde82c8ed64dfb8662f625cb8bc6245e"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad3804673a9572cfe729c47ca103a65b4b2ffc8c127b91116a28f148f7f15daf"
    sha256 cellar: :any,                 arm64_monterey: "f12a24a530a6305b25fe9147d7b83b324f2d4b65c9b4db855326e79ebd98685d"
    sha256 cellar: :any,                 arm64_big_sur:  "5f1d17b3488bf2a99c64f9e0e9651df7c297744c0a893b9e1be8afa2e4d81ec7"
    sha256 cellar: :any,                 ventura:        "cd8a4c1809b35a00a3b46b72501d380cc054ef656666218c036078ee43b24f0c"
    sha256 cellar: :any,                 monterey:       "18dd8fc65934fd6c134b598d195b92034a00ffc9b3965fac76aee2bc6f52aba5"
    sha256 cellar: :any,                 big_sur:        "cb23bcb7a7f34ac1ea45193620cebdda7e270423c18cf39aa6582aa621af0d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec4b3530f04c90dbc38f5aad836773b800c55570fb40d14ec1a46083e0fed30"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "yasm" => :build
  end

  resource "homebrew-testvideo" do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-testvideo")
    system "#{bin}/SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath/"output.ivf", :exist?
  end
end
