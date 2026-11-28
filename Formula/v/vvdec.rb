class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "8b09dbd3e3ea76972a6a2fb59e96b81a9c953f414e69f8a1b5a23eeca5bc2600"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    manifest_sha256 "4c040922dd7632f456bca6694c73a21388e59e0ce6d04ac833629c9d17bd69aa"
    sha256 cellar: :any, arm64_golden_gate: "3dda1e912c843aadec9e67b16ede9f8253250f3b1ff45bca2a788532f9c1b12a"
    sha256 cellar: :any, arm64_tahoe:       "6221a50ee5cd77e9ebb307854029dab189a80bf96de86149e3b1ca0773a60d8e"
    sha256 cellar: :any, arm64_sequoia:     "568e0a69764622a88b31db393ade2aad0903985b742545425afe345fd9aad458"
    sha256 cellar: :any, arm64_linux:       "d84d9111fc92cfe888034c70919bab92e4ab6e38c0a99fbfe125041b5f99161b"
    sha256 cellar: :any, x86_64_linux:      "80bf80167a0d2308a01b4a794d45d9b9c90fcbdbcf076240ce14377e117ff659"
  end

  depends_on "cmake" => :build

  resource "homebrew-test-video", :test do
    url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
    sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
  end

  allow_network_access! :test

  def install
    # SIMD implementations behind the per-source `-march` flags are chosen at runtime.
    ENV.runtime_cpu_detection

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
