class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "55e9c2b7510ae7ecf686107e9ebf969079c05d763f822c571827e38a5e90dfeb"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8847792c12b9763dde04ed6f4662517a188eab3417790133f4e032ea3f3bba46"
    sha256 cellar: :any,                 arm64_monterey: "31c2a8892dc5b4f1d1d38da3a442bd9c394f69ddf282d8b8720762d9328db1bf"
    sha256 cellar: :any,                 arm64_big_sur:  "76c315c22a663356d665e915a5aec2e17c1b684ca6887e081e6c0eb542b506f9"
    sha256 cellar: :any,                 ventura:        "b547a32c07864128ae97703716c952e21cf78b896a6dc4886bf404323d7e90d2"
    sha256 cellar: :any,                 monterey:       "261d0d1f760ccbc965f2a554d4d74841d936f02bae34d34ce28a3f9433da8026"
    sha256 cellar: :any,                 big_sur:        "479c1f5d902f08c235f982e90299f51d44cd6b246f2ddff08a1f714254bca64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d476747e71a454990e8884633a4f86567f14212c928d69afb0487af5e87ac4"
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
