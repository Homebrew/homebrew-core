class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.4.tar.gz"
  sha256 "5a18fe616c2a30b56e5b2f5b9f03f405cdf2435711517ff70b076a01396ef601"
  revision 2
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "120adbe521a09623f9f13357a42eaf50113aafeb8154650cb434287fd18b5c50" => :mojave
    sha256 "2e3ca6c8ce76e9e5022f95f83bc30e7251fc55758a3ec7bb973f9887fc219822" => :high_sierra
    sha256 "aa69aae9bef9513b46ba964dbeb69104584ec5ab515c4e7a622e4476672187fd" => :sierra
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

    # qprofdiff is not yet part of the source release (it will be as soon as a
    # version is released after 4.5.0), so we only include it in HEAD builds
    if build.head?
      system "make", "-C", "contrib/qprofdiff"
      bin.install "contrib/qprofdiff/qprofdiff"
    end

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
