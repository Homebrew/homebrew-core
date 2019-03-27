class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.4.tar.gz"
  sha256 "5a18fe616c2a30b56e5b2f5b9f03f405cdf2435711517ff70b076a01396ef601"
  revision 2
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "af966034f75cc9216e051b87471c7e3201bf7498bc0922efe56bf50aec83344e" => :mojave
    sha256 "ff491bde03d10b1d517c8fec2814354fe34e47f8165a827b2942706586c24b1f" => :high_sierra
    sha256 "dcf3613255d1f4bb7c5f1a24a7786043eeb4801ba936f60c03a428e8254f3417" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    system "python3", "scripts/mk_make.py",
                      "--prefix=#{prefix}",
                      "--python",
                      "--pypkgdir=#{lib}/python#{xy}/site-packages",
                      "--staticlib"

    cd "build" do
      system "make"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
