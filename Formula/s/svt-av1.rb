class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v2.1.2/SVT-AV1-v2.1.2.tar.bz2"
  sha256 "a1d95875f7539d49f7c8fdec0623fbf984804a168da6289705d53268e3b38412"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b2187052d417aa06ddb0b41d5381dd741fe74ba7caee30ad120df6050bf78bb"
    sha256 cellar: :any,                 arm64_ventura:  "073dfc4e3cead69cd42db18976c891fdd4173bb66b53ee167bbbb90c55667c54"
    sha256 cellar: :any,                 arm64_monterey: "8aa7ef9134d2e8b9f9d0c0d2983f72ee8fd27be900af88518bb588c4fe762834"
    sha256 cellar: :any,                 sonoma:         "8805e49274f42b7224a2b5c22e567aede7c3fbd92b858e88d79bde8d4fe0ff44"
    sha256 cellar: :any,                 ventura:        "0ee6775d220397e8e1baab5f53334062e61615a31c82b0082e700cb9a856de8b"
    sha256 cellar: :any,                 monterey:       "163ee3c89d1c749268c69997b8dd62e08fd3ceaecd8f58a48c384f379581a7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa1ca4dbe40a28fbab5435f95288e1429c1bfdf24e3402c65d03f45d5f7540a"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
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
    assert_predicate testpath/"output.ivf", :exist?
  end
end
