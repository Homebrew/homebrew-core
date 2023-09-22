class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "970c5512345e7246495f8e880aa79a5c3d086a5eacdc079bf77335a6f7dda65f"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0a48a4659d494e677dff8b888c81a538a50308514cd7a053e74b5ac816c4f0a"
    sha256 cellar: :any,                 arm64_ventura:  "bebff1854fdfbc44083dd35f079a80924830680bc0ce82bfe04afa8796683e64"
    sha256 cellar: :any,                 arm64_monterey: "0e050bde4ca41f13e6003eb226305cb7462922bec2a03424558d9bdac8a756c2"
    sha256 cellar: :any,                 arm64_big_sur:  "2734830741c270793c3f8af775be81f254657f9b091bde2317b38b82f2925c19"
    sha256 cellar: :any,                 sonoma:         "594f6198f800272aeb70b40b0276ad3aa7cb32a0d045b5b3420108a6e57dc93c"
    sha256 cellar: :any,                 ventura:        "78f86364a1df51bdf8e47da46ba43e8b3093fb13b968a62d488bca139a4b006e"
    sha256 cellar: :any,                 monterey:       "3ce9625e8cf55672627339cdb93b2310f978eb96f84fda09cb309ab4158d5308"
    sha256 cellar: :any,                 big_sur:        "f7b7727843d03ab4b391668fb5e37cc29a8487beb58c981b5e986477888da095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc851a75c6b2fb4bde0dd9ea1502c6921772977a27b384633bff7afcc898f94f"
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
