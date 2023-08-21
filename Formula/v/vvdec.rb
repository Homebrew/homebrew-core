class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "82339389e8656b1e3923a42b5a99f960337906bc61473ce53b9b602fe7964cdf"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f9ff9e162c7552f63741ee60f839a468c6fde7068a955ee7390d2b10ebbf27a"
    sha256 cellar: :any,                 arm64_monterey: "95a57a30056ca739110e2e103b3cdf56eb3cd1ec5a282f45f6993d0fcdeaffd9"
    sha256 cellar: :any,                 arm64_big_sur:  "08e5e55fbbf548e9920c28c0265a39b51b2c8b48a8a6283fd182c3070162e21f"
    sha256 cellar: :any,                 ventura:        "7e5495faaf810bfffba57ea5d235a7e50ac06000479137e3384019ad4a5d121a"
    sha256 cellar: :any,                 monterey:       "d65a9f472a181f86a7f0a6c98e4ceaff07e0817b47f080fce17ef24ae83140fa"
    sha256 cellar: :any,                 big_sur:        "ce1d046e9ea457db9ba51b1a7a95ce44c6c97b5ed02493e946698ce2b4aba5f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b885b7902f94a114bb6c274956427f4a5febde46defa04be07c9736ee03383"
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
