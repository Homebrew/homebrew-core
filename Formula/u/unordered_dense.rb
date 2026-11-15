class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "862605ef21424c6c92881aac4cf8f09c3abd91c80588446c83892583228eca67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc3e044cf12b9a637985bd78f16bc2684e029b35a45447e01dcad1a3103cda5a"
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
