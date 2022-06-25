class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://www.netlib.org/scalapack/"
  url "https://www.netlib.org/scalapack/scalapack-2.2.0.tgz"
  sha256 "40b9406c20735a9a3009d863318cb8d3e496fb073d201c5463df810e01ab2a57"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?scalapack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "60ef15828d471afc36f743ade73d829c293ab259fa91fb2cd9dde198666f4cae"
    sha256 cellar: :any,                 arm64_big_sur:  "d788aed0a0d3d76c45bdfe452f321de1816a1877e890b49806ca302123cda0dc"
    sha256 cellar: :any,                 monterey:       "15b0056191daddf4ed685532db8a1b99d6ea60e172eae73ba0cfb48239363bcb"
    sha256 cellar: :any,                 big_sur:        "eb1d6d67bc3f59015f715c8d2626b7717bb76abce0a387a6a32f556b43712430"
    sha256 cellar: :any,                 catalina:       "ec0d4707f9c18c171e01751d62d105347440d3255c91a3108315a8778eb650f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "459d61da4e54f9c0080bf88d24e57d3c2c15235b3c7967845c67239380c850bc"
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
