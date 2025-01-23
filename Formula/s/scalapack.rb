class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://netlib.org/scalapack/"
  url "https://netlib.org/scalapack/scalapack-2.2.0.tgz"
  sha256 "40b9406c20735a9a3009d863318cb8d3e496fb073d201c5463df810e01ab2a57"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?scalapack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "c995d114d9ed5d64a4478188051b057f1afbda10f860a6ad05240089014525f1"
    sha256 cellar: :any,                 arm64_sonoma:   "384fa978e53d02b1a25071e9cc0d89cd47a7d8881b735a946e947dca95590f25"
    sha256 cellar: :any,                 arm64_ventura:  "82500bf38af074441e92db1599b2594959d811b0bcee284c8cc36f92120525b4"
    sha256 cellar: :any,                 arm64_monterey: "4096375cb8f2af6801d1d0bbab6465b4e057e6c685ecf5e57f9f4fac8ea3166d"
    sha256 cellar: :any,                 sonoma:         "30b66a1c884bc106b96b9e82cde6d8b1c026f24307e8d5aeddb8bf4e3f91eff1"
    sha256 cellar: :any,                 ventura:        "5e64fada8dd814c16f4a2c620e8f1dc0b784519fc697ab1df907cc906aab6c8e"
    sha256 cellar: :any,                 monterey:       "168b5c717d4f360d03990e104b18d32f16e1da9cf1b2e5b6ee88fff8a0a5b33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f792514fdcdf56ca86e9b562b3a3f5e2fef3b2e84ea2648a68d0cda1cd60653"
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
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
