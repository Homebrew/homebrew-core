class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_5.2.1.tar.gz"
  sha256 "28fb66d6107ee66248d5cf508c79de03d0621852a0ddeba7301801d3d859f463"
  revision 3

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "99db35e78ccfb979cfdb922bebf7f79ce9479d5683900d7f64110cb42c92f4c7" => :mojave
    sha256 "5c037c2cf95a26ea76672e0831ac3fbf34bb8d4378acc21dc99040f7b9b421f7" => :high_sierra
    sha256 "e4fdd5560b722e5fbb5892cde2795a5dcf18889d4f663315fa29a154a266af3a" => :sierra
    sha256 "a20af0692236e73bce9cdd4c659ba7b0c98d7dbaf2953bbf0eae4255abec0e1d" => :el_capitan
  end

  depends_on "veclibfort"

  def install
    ENV.deparallelize
    cp "MAKE_INC/make.mac-x", "./make.inc"

    args = ["SuperLUroot=#{buildpath}",
            "SUPERLULIB=$(SuperLUroot)/lib/libsuperlu.a",
            "CC=#{ENV.cc}",
            "BLASLIB=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"]

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
