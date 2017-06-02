class Viennacl < Formula
  desc "Linear algebra library for many-core architectures and multi-core CPUs"
  homepage "https://viennacl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/viennacl/1.7.x/ViennaCL-1.7.1.tar.gz"
  sha256 "a596b77972ad3d2bab9d4e63200b171cd0e709fb3f0ceabcaf3668c87d3a238b"
  head "https://github.com/viennacl/viennacl-dev.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "809b0ff014ad6fdae2337ac8dd0cde29c72fe4cb8817a7e7417e9722b7572059" => :sierra
    sha256 "cb5cd96fd4c730518b6b0e150fd15386ad71576e444bfbbd5f055e844d4a5976" => :el_capitan
    sha256 "875f61b8270246247450c0beedc9710b52d07171717dd2f9de9a493f3b4027b6" => :yosemite
    sha256 "7256e29352bcf349fda479ef6913241249db48065ce64e7daee8cfe7b96c88fd" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    libexec.install "#{buildpath}/examples/benchmarks/dense_blas-bench-cpu" => "test"
  end

  test do
    system "#{opt_libexec}/test"
  end
end
