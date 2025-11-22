class Vvdec < Formula
  desc "Fraunhofer Versatile Video Decoder"
  homepage "https://github.com/fraunhoferhhi/vvdec"
  url "https://github.com/fraunhoferhhi/vvdec/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "e3e5093acfdcbfd2159f3d0166d451d7ccabd293ed30f3762b481c9c6c0a7512"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c75e17e8c9fb124b6c6fb2f85a14e594db0fad6c28e3369f532435cb81972db9"
    sha256 cellar: :any,                 arm64_sequoia: "b7387bb4fb91bee15576802e176c48a98f0057314a88e23ba22a34cda0e698e4"
    sha256 cellar: :any,                 arm64_sonoma:  "1baa30743fbc7da43f56a1414449fde505d52c5fefbd0f40f708d8234608ebd9"
    sha256 cellar: :any,                 sonoma:        "4efbd249e28c544c82677e60af0a71e40b58c06d6141532f8b90414383f62ec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca300e6bae34c24004cad069751444ea2b7b6747478700261a2ee9518e2ff277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293646906147b719adf026300bd74aa3904f8f69451f49571b175a71dddfba1e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DBUILD_SHARED_LIBS=1",
           "-DVVDEC_INSTALL_VVDECAPP=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test-video" do
      url "https://archive.org/download/testvideo_20230410_202304/test.vvc"
      sha256 "753261009b6472758cde0dee2c004ff712823b43e62ec3734f0f46380bec8e46"
    end

    resource("homebrew-test-video").stage testpath
    system bin/"vvdecapp", "-b", testpath/"test.vvc", "-o", testpath/"test.yuv"
    assert_path_exists testpath/"test.yuv"
  end
end
