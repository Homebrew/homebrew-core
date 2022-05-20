class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/3.2.0.tar.gz"
  sha256 "df546b8b8764cacaa0e72bfeb9183586e1c64bc815174cbbecd4c9c1ef18e122"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d58e4d13f0ccef559245229ad9f096a250f51eafac1056bda9150169d314431"
    sha256 cellar: :any,                 arm64_big_sur:  "47a4dff47f2c9cbfc4ab34f135074d45220faa03ccc57b7ce4c508d882e531bd"
    sha256 cellar: :any,                 monterey:       "4c739961d32188d84c24cc04753a87cbda9ef01342daa4f5f16694dfe3a3bc92"
    sha256 cellar: :any,                 big_sur:        "8f41b782fe1b00d1a6ef5e7ef63b518ee9521c357d32fd51b19a80ee47df70be"
    sha256 cellar: :any,                 catalina:       "9a931f25d46cab530d5883b248abe1f4b3fa3a0b56082c690bb5675442c58b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c72354b2eee96a4c65fbebc9377c9388eb362b0054bbb5183d788a8b3c7fb8"
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
