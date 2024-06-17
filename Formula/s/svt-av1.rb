class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v2.1.0/SVT-AV1-v2.1.0.tar.bz2"
  sha256 "2bfd098770bba185cd1ced8e1ff389837e3dca0d8b5cfb0d97c925a61dbbf955"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b843eacec8834c587a2b0cd25de80ee65a60a07b49db0f15d029055f9133b125"
    sha256 cellar: :any,                 arm64_ventura:  "f1edb8865720344f4e4948c8da7b1c0922d5fe78001551407f03021784890f51"
    sha256 cellar: :any,                 arm64_monterey: "aa0763bb4aff892dc0f7eebd83f206db45a95d77311e2ac92a5c061125a72c90"
    sha256 cellar: :any,                 sonoma:         "46bbf89c2fc13645a70e0fb127e6c7cffde54fa2d80d6416e6103446c65293d3"
    sha256 cellar: :any,                 ventura:        "30c5bd1a44c7ccd689fd96ff57247173d58db8b1f13153f8f07bc7466f193af8"
    sha256 cellar: :any,                 monterey:       "78073d02739c5424baef87139ff11ab5ecf7039badc38756b70e7c88c84d4981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e889146385d5e64c79c2c3877b0f9626b02cbd9e4b5592b2e23b816847a7dc9"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  resource "homebrew-testvideo" do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  # Remove patch in next release.
  # Upstream PR: https://gitlab.com/AOMediaCodec/SVT-AV1/-/merge_requests/2240
  patch do
    url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/commit/c0c4e12d5a50dfce0e53e375492b4280911b2fe6.diff"
    sha256 "7c496363dc5380335fb2d7750a9acfe7146201ae2f0c97d1cb5a0cb6bc01bfbe"
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
