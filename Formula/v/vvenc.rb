class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "dd43d061d59dbc0d9b9ae5b99cb40672877dd811646228938f065798939ee174"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bf0c02468ebe04b2da19e96db653dc600c403f323121b2985ea1beec6ac8dac"
    sha256 cellar: :any,                 arm64_sequoia: "aafba28d027d7b04b59c291684f7e61abc9c234afa12c1341c78382d767e8725"
    sha256 cellar: :any,                 arm64_sonoma:  "c9c91cf6a4d48ba248e7760c6d6e02f64c63158a87b4f2613c271bdd26be73ce"
    sha256 cellar: :any,                 sonoma:        "7a092b2d4b10f9d3624620250b6f7e3b7b84e2b33c55c5c42ff97025c6580fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5783986556c6ba47a1eb3b4378bd8fba822a0f58ccfb7e3caa19021aabde8039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32293a4895fb8b742751771b247662fb7e2abec5142a7467c03fd6d00627135e"
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
    assert_path_exists testpath/"RTn23_80x44p15_f15.vvc"
  end
end
