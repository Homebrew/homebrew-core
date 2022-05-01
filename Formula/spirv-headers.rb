class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.211.0.tar.gz"
  sha256 "30a78e61bd812c75e09fdc7a319af206b1044536326bc3e85fea818376a12568"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "766e327a320f213123f6f2b5e394cae54e6d80da6f6caac0f4e4c7799b561811"
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
