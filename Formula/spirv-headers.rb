class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.224.0.tar.gz"
  sha256 "2fb1039ec6cec8943400e9b4d01d8bfe8c62a0bd1fafb7c39c56469aa247b838"
  license "MIT"

  livecheck do
    url :stable
    regex(/^sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7a263cab14ac743d43ed2a5180461d7287ef25c88c95f41a833d34a4c63130a"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    system "cmake", "-S", pkgshare/"example", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end
