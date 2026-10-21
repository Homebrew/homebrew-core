class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "5c334557a33cd93e981b84ba0e77126ef970a38e2481b67f0475db40f75379b8"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5730508d9f2f1b4dcf2f9052d56297c65816070789ef8600cd764a79aa6ec3af"
    sha256 cellar: :any, arm64_tahoe:       "1352218f4598977d77e4d36b65a0e81a8c150876005343b4adc0c03d87d372fe"
    sha256 cellar: :any, arm64_sequoia:     "e6556e1b9c9035ae08be34e913d5ecdad27759e3909dacd572dd5043878e2a4c"
    sha256 cellar: :any, arm64_linux:       "e3980a66d941e4c7d20ad40d2807b1a04ac95a144188a2d8151919394dd1b961"
    sha256 cellar: :any, x86_64_linux:      "5d8f1a90fe378b24a9d12f91d89f125279d6190a588d325a145526b812fdb94d"
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
