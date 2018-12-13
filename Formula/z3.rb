class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.3.tar.gz"
  sha256 "21620b68c373cdea0d3b2cf24020be4ecfb22eddc6629663f6e9ce31cfdc78de"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "d5d6b5c05e279d5caa53f80143f235f9dd3dc67eed67788df5a046f354afabda" => :mojave
    sha256 "ba793d139b46ede624b12daf90c9d754d675359dcd048707491ffddf7ffeea7b" => :high_sierra
    sha256 "21041ebbfe6cdbd62c0c112a400be6cdf2135ba819841ad448fcea7e9c0473bb" => :sierra
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
