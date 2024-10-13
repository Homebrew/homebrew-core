class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "91ab0c64a6f43627add65cfd2c14d074ad5830105d63fa013af274960efd4e6d"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "51f1cb1b75a6ee13ab78a306ac5de3852a15d05dac0d4b53bd8953af4fda36d2"
    sha256 cellar: :any,                 arm64_sonoma:   "6f2e30713b549361d1b26911e7d88fef58a812b1ec952999fe4d0c24826f9568"
    sha256 cellar: :any,                 arm64_ventura:  "d24841de4c36eb454ca6a5be7c844de3eb2fea61e217e16a24d2f2323e08029d"
    sha256 cellar: :any,                 arm64_monterey: "0a8dab227c7af3092bc2ccb69776cdab2cdeab89199f2f8f01de429460950b2c"
    sha256 cellar: :any,                 sonoma:         "fc5acfcf9a37e3400762c0a288b7a51e63a7199a54e1d571f7051a93b4069384"
    sha256 cellar: :any,                 ventura:        "3340379e3962efd8a7249f800bb32bb6db45fe3e855e8c44cb6ff6ae6666269b"
    sha256 cellar: :any,                 monterey:       "5f0b0da9be046b8087595eeb4c8178f7cc634b8ba7c36ad187fe7852fa89d754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146e7f0178046b0118807463f1d4a16323a390d34c7c6d7e10fe3c1de1860f39"
  end

  depends_on "cmake" => :build

  resource("homebrew-test-video") do
    url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
    sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=1",
           "-DVVDEC_INSTALL_VVDECAPP=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-test-video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_predicate testpath/"test.yuv", :exist?
  end
end
