class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/3.2.0.tar.gz"
  sha256 "df546b8b8764cacaa0e72bfeb9183586e1c64bc815174cbbecd4c9c1ef18e122"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9cca5690e0cb5a81b2aa79a99f5be650adbdabf66cf702ca54955caef32a3998"
    sha256 cellar: :any,                 arm64_big_sur:  "14a0f385edbcfc24e07ecf5c210c45496a7ed5aad6b5793cda54844aa7c95959"
    sha256 cellar: :any,                 monterey:       "f31bd5a4fc8624d35af004b0d66c210e29bf7bfd3624207e04e9886b2fac1687"
    sha256 cellar: :any,                 big_sur:        "d64134271ce4777609f50c12863dbe53daa46c20ab6f3f69b17cf85e7ccb1174"
    sha256 cellar: :any,                 catalina:       "7136448e948983b5cb8a959547df98375500edf5bc6dcc2ba628661ccea89512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060a0e1fd94e55e5ddd072c8ee07fe94ffb051849ab1d858fd5eb5d8afbe18d5"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/problems/random_prob"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsindir",
                   "-o", "testscsindir"
    system "./testscsindir"
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsdir",
                   "-o", "testscsdir"
    system "./testscsdir"
  end
end
