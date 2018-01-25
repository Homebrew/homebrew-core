class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_5.2.1.tar.gz"
  sha256 "28fb66d6107ee66248d5cf508c79de03d0621852a0ddeba7301801d3d859f463"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "ea56d9279bc469e4883304e8a3c7a78500e7ad767c2e9e756043e8b382f2f6df" => :high_sierra
    sha256 "bf92da15ea05a65a0079658c7e1ac337c2f53fd82351817bc44e159b08bf289d" => :sierra
    sha256 "0e865bc43b87f76ea4ae55d7b55460e8ea46e3606c8840baba2b1e0e57d1e605" => :el_capitan
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
