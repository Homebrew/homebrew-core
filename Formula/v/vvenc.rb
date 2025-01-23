class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "28994435e4f7792cc3a907b1c5f20afd0f7ef1fcd82eee2af7713df7a72422eb"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a19d7f4402f06759d7f270a5fdc5f020617b2a9ffe341e11858cd6676949914"
    sha256 cellar: :any,                 arm64_sonoma:  "cdbbb243d7e900ded36f966c3843ba353833d178a22d62e0d2581558d3528191"
    sha256 cellar: :any,                 arm64_ventura: "1d5aa565dc36ae8e3433f4f93b8eecbe1f6bde43fb66eacb9aa834a1a2597ee3"
    sha256 cellar: :any,                 sonoma:        "1ccf83d2dd5b8f41ee83a469cfef3a3925571124eab263e74753bac0be5bf195"
    sha256 cellar: :any,                 ventura:       "5047f6ac1a59f405b328502d32553f86099a13887214d7e547935af9986f2bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab6befb73b40836dab61c28558e09bbf1104a8477db230f8767f7050c79e5b4"
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
