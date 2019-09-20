class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.6.tar.gz"
  sha256 "37922fa5085170cad6504498d9758fb63c61d5cb5b68689c11a6c5e84f0311b3"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "67c0f04c418426399348b07a60523b56551fb379a82caa5e9b1645d4ac5dea65" => :mojave
    sha256 "0379fcfacb4a0ceafb670855924604609c056b3bedbc6c7191bd937898026ef7" => :high_sierra
    sha256 "6b58192eab08a5e4da344c2811f448ea0bb148d84dfdf3d3729df76bbc468825" => :sierra
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
