class Viennacl < Formula
  desc "Linear algebra library for many-core architectures and multi-core CPUs"
  homepage "https://viennacl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.1.tar.gz"
  sha256 "a596b77972ad3d2bab9d4e63200b171cd0e709fb3f0ceabcaf3668c87d3a238b"
  license "MIT"
  revision 1
  head "https://github.com/viennacl/viennacl-dev.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3b6b46db6eefa5b811d7b2ca7e1d6bf2de9946cba356f54e9fea0a3f69511877"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  deny_network_access!

  def install
    args = %w[
      -DBUILD_EXAMPLES=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/benchmarks/dense_blas.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"dense_blas.cpp", "-o", "test", "-O3", "-DNDEBUG"
    system "./test"
  end
end
