class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/releases/download/z3-4.7.1/z3-4.7.1.tar.gz"
  sha256 "d165d68739ee15b4b73c0498225982d5a048e909e5e851b73fa6bcc7cfe228ab"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "ff2c5ce221dafc1d79b7dda798d1ec6b3bb76e087ca6302180f18426571b623e" => :high_sierra
    sha256 "9c3799db2677fdc562b9c99b91088e3f267552b316bd16e8331bf9eccb7598fb" => :sierra
    sha256 "811f63f8ff66bb8b9eef07e787f8bdc528b3bb9e2da419b71d8d970dfdb47238" => :el_capitan
  end

  option "without-python@2", "Build without python 2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "python@2" => :recommended
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
