class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v3.0.0/SVT-AV1-v3.0.0.tar.bz2"
  sha256 "852d3be2cea244dc76747a948dfcffb82d42dc42e1bd86830e591ea29b91c4fd"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3f0d3053f8a54fc6fa5caa6e1919b0e51d8dd5eb5edcdfa6416d62949655d26"
    sha256 cellar: :any,                 arm64_sonoma:  "2bf3193467977046d5ef71ee2a4aa24109783c21e36daf168daa343aab0d92d8"
    sha256 cellar: :any,                 arm64_ventura: "dacfa8b73f8ad0ac60d251985feced522df46823292ee69fb229ab39d75ee832"
    sha256 cellar: :any,                 sonoma:        "371916e5ccaa49612d526d09e480e5bc354c81024b79eb4691c10bd0a1b5105d"
    sha256 cellar: :any,                 ventura:       "4fdfe36af2a2dda9dc62ed6c29317c78c45f40aae896d69a2b7467abc19d0ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87fca934604b26adc20f188d5cf9eead041d3cf3a918a79cf518ccb1ea550d6"
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
