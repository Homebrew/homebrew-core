class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v3.0.0/SVT-AV1-v3.0.0.tar.bz2"
  sha256 "852d3be2cea244dc76747a948dfcffb82d42dc42e1bd86830e591ea29b91c4fd"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "605135cabe91df094a30c1fcbbbbce1915b7847de7ef8d46ab7bb0bee5c5f1e5"
    sha256 cellar: :any,                 arm64_sonoma:  "ae9857ada8e720c1554c6d46bf32c91b8c2b78aa07c0df4ea936ecd91d3e7863"
    sha256 cellar: :any,                 arm64_ventura: "6327e22f6630352beaac4edb8f7b362c92248d31078444e0981f6dcea172dca2"
    sha256 cellar: :any,                 sonoma:        "7b9aabe63f4fe63854e7e6ca8a23c20ee5c8aad1232a2da3c9e32cfcc516b660"
    sha256 cellar: :any,                 ventura:       "ea80f7ef7a52e89746296794dba5459524420bd68b26ef5df43e16600b1d1154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0912347393354e14ffc4198e0d56ef10b0defc45576a543dcc2a0a4e75cb8a74"
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
