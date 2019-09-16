class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/2.1.1.tar.gz"
  sha256 "0e20b91e8caf744b84aa985ba4e98cc7235ee33612b2bad2bf31ea5ad4e07d93"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/data/small_random_socp"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rw.h>
      #include <scs.h>
      #include <util.h>
      int main() {
        ScsData *data; ScsCone *cone;
        const int status = scs_read_data("#{pkgshare}/small_random_socp",
                                         &data, &cone);
        ScsSolution *solution = scs_calloc(1, sizeof(ScsSolution));
        ScsInfo info;
        const int result = scs(data, cone, solution, &info);
        scs_free_data(data, cone); scs_free_sol(solution);
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
