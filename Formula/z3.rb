class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.11.2.tar.gz"
  sha256 "e3a82431b95412408a9c994466fad7252135c8ed3f719c986cd75c8c5f234c7e"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "abc4cedf94262714a5a45f48909a6346ac8d0ee1717df35ec1b659eb4edb1eae"
    sha256 cellar: :any,                 arm64_big_sur:  "721683d8c04b84f54408c44ee53de964d11ef33c10d92c36271a03189159fd4b"
    sha256 cellar: :any,                 monterey:       "c649ba39e3d18097384be44a30dfab880c259dc88ec1d2ff398b53d3f5b7d702"
    sha256 cellar: :any,                 big_sur:        "2a08d6ad960c277f90aabf328e77962f10edf4c00053147f47c0c949c0a21915"
    sha256 cellar: :any,                 catalina:       "8f2bd926de69591c576aff590b7736ba37d4f8d7df7dfd29cf3771477ab94a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a2f13c5db8e11499d6e198101d1f3286b32575eeefbca3e80f30bf78f375a1"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

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
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
