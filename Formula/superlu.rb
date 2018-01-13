class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_5.2.1.tar.gz"
  sha256 "28fb66d6107ee66248d5cf508c79de03d0621852a0ddeba7301801d3d859f463"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "e1753077d759920bdd9cf128970c7c7b6519c3f69b80b16ae819d5cf2c6dded0" => :high_sierra
    sha256 "d447474f77bbd417d76c0fb4dfbbc9d824d344639c8ca467d9ee9c9abd3acd09" => :sierra
    sha256 "0944f8fb532af54aa50d962807568394f1cc0339710c981546a5c827faa5304f" => :el_capitan
    sha256 "c138cf46fd369e931fb858639c1b02109ad3c76e97e7f7873ddd324b3d5106e7" => :yosemite
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
