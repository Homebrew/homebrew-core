class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.10.2.tar.gz"
  sha256 "889fd035b833775c8cd2eb4723eb011bf916a3e9bf08ce66b31c548acee7a321"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eb0123d654aa2ae195581711ba49909e0b8f2d561325c96cef3b18b0ba195f4b"
    sha256 cellar: :any,                 arm64_big_sur:  "5452e5ff7b81055b5f2ba2829b88dc34271c3a974e23952d93d6c7b329eaff28"
    sha256 cellar: :any,                 monterey:       "296b6f17a19866e5584f2c0726419d6acf9aee85165c46027e2dfb0b380c458d"
    sha256 cellar: :any,                 big_sur:        "26c5ad374df3af8bf04f8dec610eab02513099c0681816122e774dd9aa658680"
    sha256 cellar: :any,                 catalina:       "8142a915cc19ac71d057fda89c993b593fcaffdf97b930833f9cf5149ec72bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e700c8d8b9ed45b0e14a73e3a6dc8a471ee0e47f41ab2a7d9c9170b0a92c4c9"
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
