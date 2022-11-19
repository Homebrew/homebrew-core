class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://github.com/xiaoyeli/superlu/archive/v5.3.0.tar.gz"
  sha256 "3e464afa77335de200aeb739074a11e96d9bef6d0b519950cfa6684c4be1f350"
  license "BSD-3-Clause-LBNL"

  livecheck do
    url :homepage
    regex(/href=.*?superlu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f6b4dbf526e0617cce7676aa335838964d2cde06f0a898d85f4775ef04673da"
    sha256 cellar: :any,                 arm64_monterey: "9f4ff68d59c8d6fa46ee8dec38a16d132b768f0774bde07ce47382df778f157f"
    sha256 cellar: :any,                 arm64_big_sur:  "8ce0014c1d671eb0666d67f7955b949e64cfa4832bb4866a3d21c7969b437253"
    sha256 cellar: :any,                 ventura:        "6296bd9709682fe5306fbc41211779c731699144c5ef3199d50058d52c7000c7"
    sha256 cellar: :any,                 monterey:       "6c7230e94eb371e7246b0072cde205acff5bc1005269e35de715261ef3c62c94"
    sha256 cellar: :any,                 big_sur:        "222e4aa99af82d75fea366fe28228913b6f8590d973b836cf2f8244a61bd1079"
    sha256 cellar: :any,                 catalina:       "032023b04d6ded07dabc261fe7dc90960e7c2f0eff162a5827c475f926f4c483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e89b55953dc32b96d18eb672895262206bb97e648b6d226b9d10741fc7eb78e"
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
