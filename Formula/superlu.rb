class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "https://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_5.2.1.tar.gz"
  sha256 "28fb66d6107ee66248d5cf508c79de03d0621852a0ddeba7301801d3d859f463"
  revision 4

  bottle do
    cellar :any_skip_relocation
    sha256 "c8cf07d7ce9841af6f5ff93f3bab779c385e0c6f84ac1c5a49d6c16ac2275120" => :catalina
    sha256 "d47a98b1d94b041aa93835c10e024f2e3bb4f6535f1dd5c142343e5cf395e785" => :mojave
    sha256 "5e02b75c1053a83ae4d07e3450d1cff929b825e2296327cbae038ace4d077e3a" => :high_sierra
    sha256 "f2038e0b4edb755631cc4f9b42dc362996d8161fa9aad306a412c7e8ff39d9f8" => :sierra
  end

  depends_on "gcc"
  depends_on "openblas"

  def install
    ENV.deparallelize
    cp "MAKE_INC/make.mac-x", "./make.inc"

    args = ["SuperLUroot=#{buildpath}",
            "SUPERLULIB=$(SuperLUroot)/lib/libsuperlu.a",
            "CC=#{ENV.cc}",
            "BLASLIB=-L#{Formula["openblas"].opt_lib} -lopenblas"]

    system "make", "lib", *args
    cd "EXAMPLE" do
      system "make", *args
    end
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
                   "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    assert_match "No of nonzeros in L+U = 11886",
                 shell_output("./test < #{pkgshare}/g20.rua")
  end
end
