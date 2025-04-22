class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "090688c2f9beebd4e8a2ec197a5b9429803498cd3c91fbec62fe7718a8268114"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b956fabeb934f949925f8671518902161fd38277e72106964a43b49c48d8c031"
    sha256 cellar: :any,                 arm64_sonoma:  "8f9c6a6c8c81c797a68a0b25487784e3dc66a5e0ca7972900d65a2dab9793de6"
    sha256 cellar: :any,                 arm64_ventura: "2554098c8f97cff5cc2b85325a3e53bfc311e9faa9ee2051d9d80e8f20bae1bb"
    sha256 cellar: :any,                 sonoma:        "b1fc2efdf0309717ea11531baccc04c608255d388239c0c4718786e3f3dca834"
    sha256 cellar: :any,                 ventura:       "618b27f29d85a69c088a927c66f463abad82db277f31090e5d71fba38b41857e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be35dcb2b448927fe23a662f37dc29656e74e4d6e7f0f5e76e3404e37b25cbee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba30c7153eef5cfcd61dab7bc0b615dadb12b4d6243d98386349237f60534221"
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
    assert_path_exists testpath/"test.yuv"
  end
end
