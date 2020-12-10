class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://portal.nersc.gov/project/sparse/superlu/superlu_5.2.2.tar.gz"
  sha256 "470334a72ba637578e34057f46948495e601a5988a602604f5576367e606a28c"
  license "BSD-3-Clause-LBNL"

  livecheck do
    url :homepage
    regex(/href=.*?superlu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e2fa1a18ee92012ef4fbdae9a6f586eee8cc4fef902663282ccf012e04b362c1" => :big_sur
    sha256 "c8cf07d7ce9841af6f5ff93f3bab779c385e0c6f84ac1c5a49d6c16ac2275120" => :catalina
    sha256 "d47a98b1d94b041aa93835c10e024f2e3bb4f6535f1dd5c142343e5cf395e785" => :mojave
    sha256 "5e02b75c1053a83ae4d07e3450d1cff929b825e2296327cbae038ace4d077e3a" => :high_sierra
    sha256 "f2038e0b4edb755631cc4f9b42dc362996d8161fa9aad306a412c7e8ff39d9f8" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "openblas"

  def install
    args = std_cmake_args + %W[
      -Denable_internal_blaslib=NO
      -DTPL_BLAS_LIBRARIES=#{Formula["openblas"].opt_lib}/#{shared_library("libopenblas")}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Source and data for test
    pkgshare.install "EXAMPLE/dlinsol.c"
    pkgshare.install "EXAMPLE/g20.rua"
  end

  test do
    system ENV.cc, pkgshare/"dlinsol.c", "-o", "test",
                   "-I#{include}/superlu", "-L#{lib}", "-lsuperlu",
                   "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    assert_match "No of nonzeros in L+U = 11886",
                 shell_output("./test < #{pkgshare}/g20.rua")
  end
end
