class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/refs/tags/3.3.2.tar.gz"
  sha256 "21c06eca0279ca3561bc8b13a4a48dab553b2e7fec337445c2186ec2d4904cf3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d3a72013589ec2d7a16cddc2683f6f3ce6fa0a23bfe2f34a3d432fd377f12c80"
    sha256 cellar: :any, arm64_tahoe:       "d8b0062394bfa6efeb6a1e4ca206ac2457f54413a8e29a871bac300e7b130ae9"
    sha256 cellar: :any, arm64_sequoia:     "cd0ff4ffdb21e327337614ebc61be0eaaa15a5811e5639e6bc0581913441874c"
    sha256 cellar: :any, arm64_linux:       "501aa341a0e66da9e399829ecd3d67d6c811fe6d68393217671987c75d1c6260"
    sha256 cellar: :any, x86_64_linux:      "a0e5f8233757d02c085139c16841dc69eaef7601535dc1605df7c511027aa60b"
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
