class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.7.0/SVT-AV1-v1.7.0.tar.bz2"
  sha256 "e7995dfc8774f301ac94367a2e5d266dc855cf62ee3d39a635f3a014708e98e1"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b16ee8c3b0a40b9e056c2105b0d2d756083cfd8bfd2415a0370761414a1af6a"
    sha256 cellar: :any,                 arm64_ventura:  "e3d3c790253851281b118345a97076207dd36b928b8326ff99a269f76ae02ec5"
    sha256 cellar: :any,                 arm64_monterey: "6476206050d975241a2e24ae93f12dc14e01e4594aa75b3a45041ac952f6b79e"
    sha256 cellar: :any,                 arm64_big_sur:  "eec30d85d2f280ba5fa1faa10f97803cb5b892ce354c5f8bc136d106a6ee0fae"
    sha256 cellar: :any,                 sonoma:         "60560a02f82d07099aef242a0fac87f39bf21453f7d41aa1df9b6d3c1dee8239"
    sha256 cellar: :any,                 ventura:        "74ca98a7094b2387913de53562b2ea400d2b8e716b2471a17d477fbb4e2f9057"
    sha256 cellar: :any,                 monterey:       "54e7cb0403f3cae14778a11c31f6fadb2be9896919f42dfaa19f022fcd90c5cf"
    sha256 cellar: :any,                 big_sur:        "3a1eb654c58c71c1417e98b9214f99fa599e836b21794079b46a316f19541dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c66585b1bdb7ab97f3e36ac1c2b29bdfb1a5159935d88146e3a2f9ff7778563"
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
