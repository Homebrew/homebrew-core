class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v5.3.2.tar.gz"
  sha256 "b406f056813da38755b4ad3366b58a8a2a4d2fa6b4a0448722800e4a675fcd03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8e599a76891753784e9eb24d19c5bb2819426669bda51387f5fbb5eba7d003d"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/main.cpp", testpath
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test"
    system "./test"
  end
end
