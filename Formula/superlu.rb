class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_5.2.1.tar.gz"
  sha256 "28fb66d6107ee66248d5cf508c79de03d0621852a0ddeba7301801d3d859f463"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da0a3f34d830f98c467c9ee7bea858a12dc4796114a6493117e40599a9259df9" => :high_sierra
    sha256 "9505e09c35bcca4b225105c4246a6f468ae5e4e9c9221fbe1ce87d0a00313144" => :sierra
    sha256 "06f41b65899b9a9a775aca3ce57de24d268f2522b4db5d1425b672f3a784ae82" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "openblas" => :optional
  depends_on "gcc" if build.with? "openmp"
  depends_on "veclibfort" if build.without? "openblas"

  fails_with :clang if build.with? "openmp"

  def install
    ENV.deparallelize
    cp "MAKE_INC/make.mac-x", "./make.inc"

    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      blas = "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    end

    args = ["SuperLUroot=#{buildpath}",
            "SUPERLULIB=$(SuperLUroot)/lib/libsuperlu.a",
            "CC=#{ENV.cc}",
            "CFLAGS=-fPIC #{ENV.cflags}",
            "BLASLIB=#{blas}"]
    args << "LOADOPTS=-fopenmp" if build.with?("openmp")

    system "make", "lib", *args
    lib.install Dir["lib/*"]
    (include/"superlu").install Dir["SRC/*.h"]
    doc.install Dir["Doc/*"]

    # Source and data for test
    pkgshare.install "EXAMPLE/dlinsol.c"
    pkgshare.install "EXAMPLE/g20.rua"
  end

  test do
    system ENV.cc, pkgshare/"dlinsol.c", "-o", "test",
                   "-I#{include}/superlu", "-L#{lib}", "-lsuperlu",
                   "-L#{Formula["veclibfort"].opt_lib}", "-lvecLibFort"
    assert_match "No of nonzeros in L+U = 11886",
                 shell_output("./test < #{pkgshare}/g20.rua")
  end
end
