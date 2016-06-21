class Viennacl < Formula
  desc "Linear algebra library for many-core architectures and multi-core CPUs"
  homepage "http://viennacl.sourceforge.net"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.1.tar.gz"
  sha256 "a596b77972ad3d2bab9d4e63200b171cd0e709fb3f0ceabcaf3668c87d3a238b"
  head "https://github.com/viennacl/viennacl-dev.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fa897aa195c281bc8aab8f14b5a824c9618f2bddc3fe859341d16a389223d52" => :el_capitan
    sha256 "4cf0ec1d9cd95e267de40fd83977fa499c01aff3eeb5cac09fad245a6ed67f2f" => :yosemite
    sha256 "9383c36ab840e0ce9599d283190711d7c3d6a25d1d3bd99970b409028ebb2bc9" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :macos => :snow_leopard

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    libexec.install "#{buildpath}/examples/benchmarks/dense_blas-bench-cpu" => "test"
  end

  test do
    system "#{opt_libexec}/test"
  end
end
