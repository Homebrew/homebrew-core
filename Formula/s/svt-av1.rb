class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v3.1.2/SVT-AV1-v3.1.2.tar.bz2"
  sha256 "802e9bb2b14f66e8c638f54857ccb84d3536144b0ae18b9f568bbf2314d2de88"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b59de84414e36b3651703cdbcbe068a738fb5376639be5acb73944b826dff121"
    sha256 cellar: :any,                 arm64_sequoia: "8c2b600f85d7ff7280fbfb1eadf0c184389851b0b45181e38ab83471b172e5d9"
    sha256 cellar: :any,                 arm64_sonoma:  "e99263f68834a04809be5b69f86f009ba5907b0fbb053c74ca30ab19ccd48090"
    sha256 cellar: :any,                 arm64_ventura: "4b18d8c80857d654acfff1ba38f33d8571be5e26832cd6cdcfb9d0225dd56d6f"
    sha256 cellar: :any,                 sonoma:        "88ac875b64040b98495de3bc0beb26c5806e1bb7abe6d7ccc39a1cc9d60dfa59"
    sha256 cellar: :any,                 ventura:       "83c8622df46a28226294405d21ea13feaa608a5814743e1b46e5479a52ee43d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d7efc983029cd1bb5f3cbcdfa09d2f8f1e344a3853d4325c01de798374f9e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42ae8505f47c43db4757b07adc84e684ebb5dbbd166919d7bd583ac2ff3dcf9d"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

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
