class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://portal.nersc.gov/project/sparse/superlu/superlu_5.2.2.tar.gz"
  sha256 "470334a72ba637578e34057f46948495e601a5988a602604f5576367e606a28c"
  license "BSD-3-Clause-LBNL"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?superlu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_big_sur: "70e9312167959d574969c9853b78f8c862ecd9e4350d1e37e8bb0529764d7cb7"
    sha256 cellar: :any,                 monterey:      "581f43b83ba13034fbedcb4ed3a0de247340b6b2d6b41251e5df6cb54e1e3ed8"
    sha256                               big_sur:       "31635c3e8dc6dbd1401509c09812d28063c1e2de9ba0f6b234bedb88be9488d3"
    sha256                               catalina:      "9d40cab963df57b12521fe8150b19f37a8b969c8f4c6a0454767fdda0719c298"
    sha256                               mojave:        "ad6d7e6dab5b4f937fb99468d53d93f1d6eb28b095f95c809d99104d766e38ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb89f9777616120bf74ce7d1478513478e29ea0054e782e960b7cbed09f155f"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "openblas"

  def install
    args = std_cmake_args + %W[
      -Denable_internal_blaslib=NO
      -DTPL_BLAS_LIBRARIES=#{Formula["openblas"].opt_lib}/#{shared_library("libopenblas")}
      -DBUILD_SHARED_LIBS=YES
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
