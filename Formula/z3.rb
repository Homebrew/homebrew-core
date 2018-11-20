class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.3.tar.gz"
  sha256 "21620b68c373cdea0d3b2cf24020be4ecfb22eddc6629663f6e9ce31cfdc78de"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "79fd1b14363382d685f2927131885bee9e45c43bfea1da4bf8d80bd93afba126" => :mojave
    sha256 "5ef2bfe779aeea034f72d8d91d179938e329bd02bd80ba4373c90092a6d60d3a" => :high_sierra
    sha256 "2f0f1d4e8dd7c4a17a3837b60bde87ead9a8d32d8ea3463579ae3d2df067200c" => :sierra
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
