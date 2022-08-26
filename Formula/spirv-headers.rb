class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.224.1.tar.gz"
  sha256 "c85714bfe62f84007286bd3b3c0471af0a7e06ab66bc2ca4623043011b28737f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d61b6d9efaf89b5d185f295ebd6c68d837700622013a18a8761f59173f6419e1"
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
