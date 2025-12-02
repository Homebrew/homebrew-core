class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/refs/tags/3.2.9.tar.gz"
  sha256 "f3d9095fb01fd634d12ccbe6f79ed2acbb7101ad57b723157d44a49cbe187669"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c13642cfe0453436d0f43eb39566f75e4f04c5849d4b973e317f7899a1672fc7"
    sha256 cellar: :any,                 arm64_sequoia: "461fe0b74cc5dd41fd8a031ac729c6237314ede47f6d428496ef6074cc6e6bab"
    sha256 cellar: :any,                 arm64_sonoma:  "d2314d0694a4d2229a6db429a356a6440905b57c103614ee9727ec40a16a4c5a"
    sha256 cellar: :any,                 sonoma:        "4f24992de230bab0d597b13150db3b449efeaf277a2c0de28f3b02b9a2c2a45b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "915268f6799f763232f4e5ec19fc7fe515d01e3d6b1be601999a88592c575c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4f323c865ab69e6d5235aeecf07387a9db01849082f82caeb1abb624eec1557"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/problems/random_prob"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rw.h>
      #include <scs.h>
      #include <util.h>
      int main() {
        ScsData *d; ScsCone *k; ScsSettings *stgs;
        ScsSolution *sol = scs_calloc(1, sizeof(ScsSolution));
        ScsInfo info;
        scs_int result;

        _scs_read_data("#{pkgshare}/random_prob", &d, &k, &stgs);
        result = scs(d, k, stgs, sol, &info);

        _scs_free_data(d); _scs_free_data(k); _scs_free_sol(sol);
        return result - SCS_SOLVED;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsindir",
                   "-o", "testscsindir"
    system "./testscsindir"
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsdir",
                   "-o", "testscsdir"
    system "./testscsdir"
  end
end
