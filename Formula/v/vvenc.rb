class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "e7311ffcc87d8fcc4b839807061cca1b89be017ae7c449a69436dc2dd07615c2"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "91e5d0c5676234434e2d2fd466ae3a34a116a7f7bbc777a316b15b5ab5c9618d"
    sha256 cellar: :any,                 arm64_sonoma:   "1c5857d284bf4fc94769c6248a811372bbb813b1c09d03cdf9bca872f7b91f95"
    sha256 cellar: :any,                 arm64_ventura:  "823efb6a8e5732bac2e800fd5dbd11f289b27cf595a6271abcc9aeae736b0694"
    sha256 cellar: :any,                 arm64_monterey: "f8a0ba66ab0d1ea35ac45dba888aee3a5afff8a10f4e604f1fa34d07fa45e8cd"
    sha256 cellar: :any,                 sonoma:         "694b46e96049b0431de6dcca89e8006df5fa46d22add11403a28ac5bb0fe8937"
    sha256 cellar: :any,                 ventura:        "292ba473af86af725c8fc75cd58ab440dcf5596a81f1c31de42109f947d47548"
    sha256 cellar: :any,                 monterey:       "541ff6ce51eee6e54248b6b6cec15a593dd84d93a9db873394847f4746dff2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c1d047079359eedcacab0179d81c285d6d27f0a8ed81ff6707017d491802df"
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
