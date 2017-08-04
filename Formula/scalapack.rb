class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "http://www.netlib.org/scalapack/"
  url "http://www.netlib.org/scalapack/scalapack-2.0.2.tgz"
  sha256 "0c74aeae690fe5ee4db7926f49c5d0bb69ce09eea75beb915e00bba07530395c"
  revision 8

  bottle do
    cellar :any
    sha256 "2bbbb6168843fd0c4d625eae362d5998b5b1d51f2b2cdb3c2bac1c3389a6f8ae" => :sierra
    sha256 "1273e195bb17b4d178f06ad336f96d8a42038c4a98be8d13d25401e8a44bd193" => :el_capitan
    sha256 "d91bd993babb651afeffc48932d6343fbb6f73c698708f583dde18e9a69666f9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :mpi => [:cc, :f90]
  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without?("openblas")

  def install
    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      blas = "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON",
                      "-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{blas}"
      system "make", "all"
      system "make", "install"
    end

    pkgshare.install "EXAMPLE"
  end

  test do
    ENV.fortran
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
