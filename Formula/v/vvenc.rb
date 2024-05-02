class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "4f0c8ac3f03eb970bee7a0cacc57a886ac511d58f081bb08ba4bce6f547d92fa"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ef69a06ffcb3d7fd9008ae3c0869a96a66a87dffe950dad5099bba9c0bfcf1f"
    sha256 cellar: :any,                 arm64_ventura:  "9ffcfa4737a00c4e4a5d0039a3c470dc33152044add990af6f0dc86464e737f1"
    sha256 cellar: :any,                 arm64_monterey: "9678495781b1bd6ec1d4a9bc2edc5078c2c1a2b6cacc11837a6b2022bdc2207d"
    sha256 cellar: :any,                 sonoma:         "7fbde738989b279e292d93caf38953dc4cb04ae71febf01fa116b4ba5776d483"
    sha256 cellar: :any,                 ventura:        "4a5ca70c24e3340e16ecb5d37fb3e1d7fcd66f9d05fe036a13c5ee88bd981479"
    sha256 cellar: :any,                 monterey:       "9d746ddaade543aefd79ff53f4df6a9926055a98b62f60af9aaee08d8c2033cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71af4b680931c70317112bbdaaf1b5c53f9cec28f667813d766f4b10f6efbff1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVVENC_INSTALL_FULLFEATURE_APP=1",
           "-DBUILD_SHARED_LIBS=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath
    system bin/"vvencapp",
           "-i", testpath/"RTn23_80x44p15_f15.yuv",
           "-s", "360x640",
           "--fps", "60/1",
           "--format", "yuv420_10",
           "--hdr", "hdr10_2020",
           "-o", testpath/"RTn23_80x44p15_f15.vvc"
    assert_predicate testpath/"RTn23_80x44p15_f15.vvc", :exist?
  end
end
