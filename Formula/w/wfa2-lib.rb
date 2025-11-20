class Wfa2Lib < Formula
  desc "Wavefront alignment algorithm library v2"
  homepage "https://github.com/smarco/WFA2-lib"
  url "https://github.com/smarco/WFA2-lib/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "2609d5f267f4dd91dce1776385b5a24a2f1aa625ac844ce0c3571c69178afe6e"
  license "MIT"
  head "https://github.com/smarco/WFA2-lib.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0b6df4465be30f02a3550699339f680c3820ab31214f5134e1aacb3ac3939e0"
    sha256 cellar: :any,                 arm64_sequoia: "1b837b83b531386b7c1812a251f2eb030761e51799f4c812b8428844219cc670"
    sha256 cellar: :any,                 arm64_sonoma:  "fa2570af22fdf64cd38c65d1835596370dee30ca4f8c93beae65082d171ad0d0"
    sha256 cellar: :any,                 arm64_ventura: "c2b2cd3b72cad2bc5f8444f748310bd3ea87c2b8f5fc7d61892e9afb82991bc3"
    sha256 cellar: :any,                 sonoma:        "19a6a9bcef73e9d4ab9499360046695c51e256e45f34aa20509aa67672ebd38d"
    sha256 cellar: :any,                 ventura:       "22063cfd7b43825c734ed23deecc19193774a819ea75e29d3b27b84e8b67f905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "353ef4fd445ba3aa0fc83ead45dcdf670e8d864fbbe594bdd15794f638b2c53e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2df560ffb8551153a89a0c9ee9be215798c7adbac8f075ca8650538f7b20a7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DOPENMP=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/wfa_basic.c", "-o", "test", "-I#{include}/wfa2lib", "-L#{lib}", "-lwfa2", "-lm"
    assert_match "WFA-Alignment returns score -24", shell_output("./test 2>&1")
  end
end
