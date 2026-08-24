class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v4.2.0/SVT-AV1-v4.2.0.tar.bz2"
  sha256 "512f2ea5649e3e76c2dddcc25c2556fb67a9582baaab207c9c96161c94659dad"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bd6186cc963d1980f0d81d59ecef58c8fa6263eb1124211dd3537b224e04c9e0"
    sha256 cellar: :any, arm64_sequoia: "2e6f7cbf3ff42f59ca251f3c84d4ad5a3ecfd518340237a6f70a54a428de1676"
    sha256 cellar: :any, arm64_sonoma:  "3aed847bbc1911739c73b53503bafa33bbf3aa15a792756db1b550738faf51db"
    sha256 cellar: :any, sonoma:        "413ca9c3ca785dcebb9baae17b4b86a70f1c86e5881fa8af87f55ac7e5d8a5eb"
    sha256 cellar: :any, arm64_linux:   "2ea5be1d189e4102b1e8c7e32c97ad01ed9958ffd898c8e6b4acbd88b6d435ef"
    sha256 cellar: :any, x86_64_linux:  "ac3f7f9240381b15060529d4fed8ee1945afddb74a44f0cee8e8741e1d29c6a4"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    # Features are enabled based on compiler support, and then the appropriate
    # implementations are chosen at runtime.
    # See https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Source/Lib/Codec/common_dsp_rtcd.c
    ENV.runtime_cpu_detection

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testvideo" do
      url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
      sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
    end

    testpath.install resource("homebrew-testvideo")
    system bin/"SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_path_exists testpath/"output.ivf"
  end
end
