class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.2.1/SVT-AV1-v1.2.1.tar.gz"
  sha256 "5c2466eb2990fa045b29c63b92a2b5f13d9cb841709df5e7206f96a59e119fdd"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9e7a30c9cdc0825abf4081957a68c59b4f4734013ad9d4ba3ce543f5d75f312f"
    sha256 cellar: :any,                 arm64_big_sur:  "4d5d51961f0d51af8613d32165b769b6507207cbf0c62aea864f183221f6a40f"
    sha256 cellar: :any,                 monterey:       "7959f3ca780349a899dbb7c38d880c8bf7a66a57c1a83b9ed09edd6cdc427f7c"
    sha256 cellar: :any,                 big_sur:        "2891635020046d26900e8559eb6f7499a39e527efa0c67830b74eb92c5b6c891"
    sha256 cellar: :any,                 catalina:       "c072ef6dce5a6fd197edbfdf1c336f6a82b9705d12dc410449a53375bca201b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026723eedeb92ac290422b47eb827484c221199189bfbbf02fd34356d457bd8c"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "yasm" => :build

  resource("homebrew-testvideo") do
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
