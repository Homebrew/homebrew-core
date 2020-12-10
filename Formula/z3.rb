class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.9.tar.gz"
  sha256 "c9fd04b9b33be74fffaac3ec2bc2c320d1a4cc32e395203c55126b12a14ff3f4"
  license "MIT"
  revision 1
  head "https://github.com/Z3Prover/z3.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "a8a2dab47dcde379343d66bc38630e96fff4f0af2a11f7ef981a7e535dab78d9" => :big_sur
    sha256 "214adde7572bc8a15e496c5d5c9e4ead2896f734c4aae4ede0769ac103668e9a" => :catalina
    sha256 "12808ffa55f75ef38a61faf4f973445a6436ccc1cae30fd29489b249fd22467b" => :mojave
    sha256 "037a6a59ab8b4c776421d4beb3583ce10b0e45b00c4dac9d8075ec56e0e9e858" => :high_sierra
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.9" => :build

  def install
    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    system python3, "scripts/mk_make.py",
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
