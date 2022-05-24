class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.17.tar.gz"
  sha256 "1e57637ce8d5212fd38453df28e2730a18e0a633f723682267be87f5b858a126"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b8749a0b889793fb7cfa72d1d380b74bdfeba5607e60d1d1deb0080dea7115bb"
    sha256 cellar: :any,                 arm64_big_sur:  "2f59c37465aecdfbcc50a5ba0fe627535c0ff4cffb9080bfbddc0a2af0f97b53"
    sha256 cellar: :any,                 monterey:       "d5dc7cb5a4a51bb544531f8ef9add76f22eda73d65c5603523c3573203b48bae"
    sha256 cellar: :any,                 big_sur:        "b71b46a3a98b756ff456a591c2cd372013fd166f7e9ee8e25ceda8f990f9880d"
    sha256 cellar: :any,                 catalina:       "2da92fd5596dd0a2c0a0b21f63bd474872933a5910a8d9f2e93619c687418a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76abc05ef9587b811f14c70f430278e47405c7d68f610e65bd2157d11c99687"
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
