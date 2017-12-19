class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.6.0.tar.gz"
  sha256 "511da31d1f985cf0c79b2de05bda4e057371ba519769d1546ff71e1304fe53c9"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "e93213ff9ec5a601e26a1a7c55dfd483bad1021c12582b199a8a1443ca7124e9" => :high_sierra
    sha256 "0f1f3d3de36a046161950aa09e2dc42e1d49deccdd12acaf1ebbb472b2250ad1" => :sierra
    sha256 "4646641c96b2369b11cd87d6cc81debf675f078fee3e0a296c8d0a0b4ce738f5" => :el_capitan
    sha256 "72feb2352c0f9d5fbbf22ae83443520bff85acd6448898a5d89ba3fe42c61566" => :yosemite
  end

  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  def install
    if build.without?("python3") && build.without?("python")
      odie "z3: --with-python3 must be specified when using --without-python"
    end

    Language::Python.each_python(build) do |python, version|
      system python, "scripts/mk_make.py", "--prefix=#{prefix}", "--python", "--pypkgdir=#{lib}/python#{version}/site-packages", "--staticlib"
      cd "build" do
        system "make"
        system "make", "install"
      end
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
