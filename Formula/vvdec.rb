class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "72de0cbcd24285e6f66209be9270f8f0c897d24e586b3876c6a7bb5691375c48"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fbba911cd7462add2a47e829d49a682ccc2146f23999ca0d461520a62d0c15de"
    sha256 cellar: :any,                 arm64_monterey: "00937d55751ec2d1aba6509e5a814f381223d9957ff0759ed4e0255ad783d2b4"
    sha256 cellar: :any,                 arm64_big_sur:  "75d9beb084c1c866c4a6c489f00457d234dabe962e1d5b1f043aa03ef1d00fee"
    sha256 cellar: :any,                 ventura:        "e03a0d675cb8e785b06de728d022b69949ca403098bd50b9c422aa4168db7357"
    sha256 cellar: :any,                 monterey:       "acef3db5aecdf1dc02653ba0b18078ba85cdc30cd011ebbe9b162cc802b8241a"
    sha256 cellar: :any,                 big_sur:        "374b8847719440b5af13e7d4b59bae3d5d3efa0e21bb5ae20280a922d95e7a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "076c4ed2955883781792470197d9798ade7620ecafa9bcfcf1a7c643d0947fdf"
  end

  depends_on "cmake" => :build

  resource("test_video") do
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
    resource("test_video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_predicate testpath/"test.yuv", :exist?
  end
end
