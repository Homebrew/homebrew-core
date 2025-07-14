class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v3.0.2/SVT-AV1-v3.0.2.tar.bz2"
  sha256 "7548a380cd58a46998ab4f1a02901ef72c37a7c6317c930cde5df2e6349e437b"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e93837b76e46e9cfff5d2826fdeb6312842353b899d3e851c81d943e3cb87b57"
    sha256 cellar: :any,                 arm64_sonoma:  "21b309a7920d93b2f017114dfb76c770406bd5238e8fdd74b68717f50f4b9b59"
    sha256 cellar: :any,                 arm64_ventura: "3c65e6a356f2f09e9c8c7f1e9ca6ed44668646c70e4385a7319c2f4a0a58b181"
    sha256 cellar: :any,                 sonoma:        "075d6d284e3c9ec2c83b0295e8a7de3a98f5e80cd20a8829ab5a8c05e72acd3b"
    sha256 cellar: :any,                 ventura:       "4e251d72c313bde400f5a8cacda21b165c28177ea7c3a16f0a56fbfb115f677b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cdfe2836145ff6d33e546172d80acb58ae823f12bd43dd11163f285c885d7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e47620efee4766014dbfe212857f627f5b04c0cd30c99f57e53c145dd553820"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  # Match the version of cpuinfo specified in https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/cmake/cpuinfo.cmake
  resource "cpuinfo" do
    url "https://github.com/1480c1/cpuinfo/archive/e649baaa95efeb61517c06cc783287d4942ffe0e.tar.gz"
    sha256 "f89abf172b93d75a79a5456fa778a401ab2fc4ef84d538f5c4df7c6938591c6f"
  end

  def install
    # Features are enabled based on compiler support, and then the appropriate
    # implementations are chosen at runtime.
    # See https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Source/Lib/Codec/common_dsp_rtcd.c
    ENV.runtime_cpu_detection

    (buildpath/"cpuinfo").install resource("cpuinfo")

    cd "cpuinfo" do
      args = %W[
        -DCPUINFO_BUILD_TOOLS=OFF
        -DCPUINFO_BUILD_UNIT_TESTS=OFF
        -DCPUINFO_BUILD_MOCK_TESTS=OFF
        -DCPUINFO_BUILD_BENCHMARKS=OFF
        -DCMAKE_INSTALL_PREFIX=#{buildpath}/cpuinfo-install
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
      ] + std_cmake_args.reject { |arg| arg.start_with? "-DCMAKE_INSTALL_PREFIX=" }

      system "cmake", "-S", ".", "-B", "cpuinfo-build", *args
      system "cmake", "--build", "cpuinfo-build"
      system "cmake", "--install", "cpuinfo-build"
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DUSE_CPUINFO=SYSTEM
      -Dcpuinfo_DIR=#{buildpath/"cpuinfo-install/share/cpuinfo"}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
