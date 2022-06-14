class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.216.0.tar.gz"
  sha256 "46c49a0e49ea120138102b1dcb3778e5a4f2267c45b9e937810a4cf4fb889e3d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0569a8ed0a9b5af6701bad2aee726b43db9661389bdf19d58c66d31024b7fea7"
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
