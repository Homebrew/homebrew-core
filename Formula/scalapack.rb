class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://www.netlib.org/scalapack/"
  url "https://www.netlib.org/scalapack/scalapack-2.2.0.tgz"
  sha256 "40b9406c20735a9a3009d863318cb8d3e496fb073d201c5463df810e01ab2a57"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?scalapack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "29ba1d098896c7724994f1c43eb6796390759a184220419ebcef8c5600f871be"
    sha256 cellar: :any,                 arm64_monterey: "a0cd4b382932d32799b88c4e7f99488414d7feb86ff5fbb1a22fa6b1980c84ea"
    sha256 cellar: :any,                 arm64_big_sur:  "564ea01e76cc0dcd9a74de0f9e9edece929059d972a7954ca139a55d0150c920"
    sha256 cellar: :any,                 ventura:        "20f2a5d450de5f8d745fc6d7c675f19bb70ee4c66ba18a4d4782418e1d0ed389"
    sha256 cellar: :any,                 monterey:       "388e65a24aa3813825a03601f2d8ca839f00b40c0b082ecf8207e30b9bc9d481"
    sha256 cellar: :any,                 big_sur:        "db51a021b6af840cafb460e91c766312e01f646834a48c36e0e566f95f89b8d3"
    sha256 cellar: :any,                 catalina:       "c829bc139bd4db1d81e578e25df05119f503210bfb52391a45c97bf534891c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d36d901de11e7a625fcb7c48c043c100a7d7fa640d61c96a41daa932e7140681"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  # Apply upstream commit to fix build with gfortran-12.  Remove in next release.
  patch do
    url "https://github.com/Reference-ScaLAPACK/scalapack/commit/a0f76fc0c1c16646875b454b7d6f8d9d17726b5a.patch?full_index=1"
    sha256 "2b42d282a02b3e56bb9b3178e6279dc29fc8a17b9c42c0f54857109286a9461e"
  end

  patch :DATA

  def install
    mkdir "build" do
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON",
                      "-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{blas}"
      system "make", "all"
      system "make", "install"
    end

    pkgshare.install "EXAMPLE"
  end

  test do
    cp_r pkgshare/"EXAMPLE", testpath
    cd "EXAMPLE" do
      system "mpif90", "-o", "xsscaex", "psscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xsscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
      system "mpif90", "-o", "xdscaex", "pdscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xdscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
      system "mpif90", "-o", "xcscaex", "pcscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xcscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
      system "mpif90", "-o", "xzscaex", "pzscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xzscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 85ea82a..86222e0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -232,7 +232,7 @@ append_subdir_files(src-C "SRC")

 if (UNIX)
    add_library(scalapack ${blacs} ${tools} ${tools-C} ${extra_lapack} ${pblas} ${pblas-F} ${ptzblas} ${ptools} ${pbblas} ${redist} ${src} ${src-C})
-   target_link_libraries( scalapack ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES})
+   target_link_libraries( scalapack ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} ${MPI_Fortran_LIBRARIES})
    scalapack_install_library(scalapack)
 else (UNIX) # Need to separate Fortran and C Code
    OPTION(BUILD_SHARED_LIBS "Build shared libraries" ON )
