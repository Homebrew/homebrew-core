class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://www.netlib.org/scalapack/"
  url "https://www.netlib.org/scalapack/scalapack-2.1.0.tgz"
  sha256 "61d9216cf81d246944720cfce96255878a3f85dec13b9351f1fa0fd6768220a6"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?scalapack[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_big_sur: "ae872ee54a2f85ef4b8a3e5370751db4d3dd931c10d3222355fa523389592c34"
    sha256 cellar: :any,                 monterey:      "e387af6b56b3a5a5466521c1e75f425903c35c7ad5c37c830be637997f10a36c"
    sha256 cellar: :any,                 big_sur:       "5d33d9c7a1f92b2a30487b6218d0fc248905f7114275fe83e661411343400ada"
    sha256 cellar: :any,                 catalina:      "0919c7e1f584fb690ce4d8e395e4b98c21d85858581eef10f1c73612216f863a"
    sha256 cellar: :any,                 mojave:        "ff1f14376cb734a26a0d5580d0e58e7107c33def1bcda522ac7af3dfcd129f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf7a2df188247f7bd79e779b2a2fa535943082c352bed86c9b454c99d3236c76"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  # Patch for compatibility with GCC 10
  # https://github.com/Reference-ScaLAPACK/scalapack/pull/26
  patch do
    url "https://github.com/Reference-ScaLAPACK/scalapack/commit/bc6cad585362aa58e05186bb85d4b619080c45a9.patch?full_index=1"
    sha256 "f0892888e5a83d984e023e76eabae8864ad89b90ae3a41d472b960c95fdab981"
  end

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
