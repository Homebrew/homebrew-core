class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.11.2.tar.gz"
  sha256 "e3a82431b95412408a9c994466fad7252135c8ed3f719c986cd75c8c5f234c7e"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "cd1bc06fbd7e30b76bb7a0f35ee0ef52a68459c27014ee90fb7a3fa588e7bbcf"
    sha256 cellar: :any,                 arm64_big_sur:  "7b5fadd9f6aae033204b2a487c7ce4717ab1f517731f19a6a11a7b4efd3af7f5"
    sha256 cellar: :any,                 monterey:       "e457a273130050594a4c71166392cad9d19e4d3159770cf6173adae279d77247"
    sha256 cellar: :any,                 big_sur:        "66edef24ae8885d0caacfa3b708b968df8d784653704cfb8052848382d6ebbd8"
    sha256 cellar: :any,                 catalina:       "62f3afca0e299f799396399839c6c0bf98f56e607a8887fcf294d3b09b10f9f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19fea9a2eade95898190d751a651886b973591ec9f2e0e8ad327cd8abf75a607"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.10" => :build

  fails_with gcc: "5"

  def install
    python3 = Formula["python@3.10"].opt_bin/"python3.10"
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
    system ENV.cc, pkgshare/"examples/c/test_capi.c",
           "-I#{include}", "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
  end
end
