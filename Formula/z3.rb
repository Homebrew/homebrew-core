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
    sha256 cellar: :any,                 arm64_monterey: "c8ad8581f7dab7e6ab8945f149e474158f7e66d92085a15183e087fa340f9742"
    sha256 cellar: :any,                 arm64_big_sur:  "5849baf1f53f04149b800eb8a5db7df5bcab1e3f6470bfcd74b0116b8baa1185"
    sha256 cellar: :any,                 monterey:       "eee2fd5d84970f78527fb7159873378819e2bb5d1ea94a19a8807ada2ce377fc"
    sha256 cellar: :any,                 big_sur:        "c6de924eaecf282d81f265a4793fd16c05a6160f131449219a802440216e3edc"
    sha256 cellar: :any,                 catalina:       "ce36c47fdb793e9eb46d73b39a1a355f26dace889d0ac4437a17efc923a88dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff06f2df5c79ccc4d94d365afa677a740e222b1232eb22e4c1563c74da12aab0"
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
