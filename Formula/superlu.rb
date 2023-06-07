class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://github.com/xiaoyeli/superlu/archive/v6.0.0.tar.gz"
  sha256 "5c199eac2dc57092c337cfea7e422053e8f8229f24e029825b0950edd1d17e8e"
  license "BSD-3-Clause-LBNL"

  livecheck do
    url :homepage
    regex(/href=.*?superlu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c3027acd72b215b30fe0037f2899aa7cdfcca6d343311007271ed87d96d80312"
    sha256 cellar: :any,                 arm64_monterey: "4995ceb2466ac63227cddfcd518c50ca044756746444f44998df047aa096d05c"
    sha256 cellar: :any,                 arm64_big_sur:  "e6935b2430b89b733c87e7d408a388ad0c73f2d0971485e571191b405451cf7f"
    sha256 cellar: :any,                 ventura:        "2b977f459bcdff15d7e6a696f7bd048de3d45977c8f28f547e4062f2d430550b"
    sha256 cellar: :any,                 monterey:       "878371ffa8e773c0a39742b496f25eb314905b48a266adc20a0267d936f5fc93"
    sha256 cellar: :any,                 big_sur:        "f52d8d7888d9a12a19dc8e320f6a610f9ed71a18de2849c86adf42e5dd58879f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bcfd31a895f26353078a7c78b80041bcc75f07f1c1774e728fa45c4739a5284"
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
