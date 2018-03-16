class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.6.0.tar.gz"
  sha256 "511da31d1f985cf0c79b2de05bda4e057371ba519769d1546ff71e1304fe53c9"
  revision 1
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "c2493989f46145689553af054cf41a7c21995fcdb5f84ab5992e2f3cc73f6e65" => :high_sierra
    sha256 "356863daa6b6701579e1840b5c069fe021a013e2cdef293e91e8984867c87804" => :sierra
    sha256 "c351bed3d338b1eff6801956915d22b86f8b00fb056b1048c8c88983aa724748" => :el_capitan
  end

  option "without-python@2", "Build without python 2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "python@2" => :recommended if MacOS.version <= :snow_leopard
  depends_on "python" => :optional

  def install
    if build.without?("python") && build.without?("python@2")
      odie "z3: --with-python must be specified when using --without-python@2"
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
