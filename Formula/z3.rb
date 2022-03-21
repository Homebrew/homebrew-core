class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.15.tar.gz"
  sha256 "2abe7f5ecb7c8023b712ffba959c55b4515f4978522a6882391de289310795ac"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c08c76148660373a15f268ac97d8f9bbe588a8fc9c4110696611d7de5426fb3b"
    sha256 cellar: :any,                 arm64_big_sur:  "884f1128a33ea7dea3ad375e50ef5ea36b26623e2999119cf31252dd4650692f"
    sha256 cellar: :any,                 monterey:       "ed92f871bf8581d2727cdaac80458180b403da8a0c724aa379528614b909621a"
    sha256 cellar: :any,                 big_sur:        "62cd495aca5ea782de53e47b812706620a2b87b0949a09cec54bef2555c81230"
    sha256 cellar: :any,                 catalina:       "ab18f92c882f92e413ddd2d9584cdb76abdf9962d19f378a255365c96d57459e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e2ca52b39f7d29e420add82c44c31e0ce1afaae8ae5058d5ac3f2ad07a7478"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    python3 = Formula["python@3.10"].opt_bin/"python3"
    system python3, "scripts/mk_make.py",
                     "--prefix=#{prefix}",
                     "--python",
                     "--pypkgdir=#{prefix/Language::Python.site_packages(python3)}",
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
