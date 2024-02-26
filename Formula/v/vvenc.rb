class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "b586bbfd8c2e539b1308cb1af13b7e595d6464973339dcef9414c503e663a09f"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c58593b1ab2509f578021d97e0941fdb41f8cea53fbf3ca2731293b347c78f3"
    sha256 cellar: :any,                 arm64_ventura:  "69cd2ee448d4dcacdbd0c1c2d52940572b9a38bb93d6c3225aa10ffead2eb79b"
    sha256 cellar: :any,                 arm64_monterey: "a4c7d0eb6fd37eb3cfa6b7cbe6046ba44f7af2c364ca35fc5f56fdfc7a405866"
    sha256 cellar: :any,                 sonoma:         "b2efad3b698c5048ed68155316ac68e4a98be9322358d4bb61b8b03526375fa3"
    sha256 cellar: :any,                 ventura:        "7ebd59d924fd5b693b17053775d8ab547d9bca8dfdd6dd1a98eca367c9a785a0"
    sha256 cellar: :any,                 monterey:       "53697d42a2d0cd4a16e2bed94d2e304623f4347e0d943811335eaad3f7a027cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6161e1fbfca46fc4c5af1e63086b412903a31fc3261e77899282fc9248a1ef49"
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
