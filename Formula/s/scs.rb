class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/refs/tags/3.3.1.tar.gz"
  sha256 "99a1437b2508ed29933d259793a5745f29000fd8ec58f63a8f54a20006aacb86"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c8bf35ba1df7366ea18fb577de9d8c0c5e7dd262777ba45b0a62c4ffef7b10d"
    sha256 cellar: :any, arm64_tahoe:       "f6db9d51d776c83d15310e412256a9c52a53292eb7d8e77ec37d4df2461e5001"
    sha256 cellar: :any, arm64_sequoia:     "82c780f7adb1edc692c76a568269a007dd2a558db460a099d5f3e5729108a832"
    sha256 cellar: :any, arm64_sonoma:      "f576116ddb1df674d825bed9e3b87181b2666460262dc2da58fb70ac39c40626"
    sha256 cellar: :any, arm64_linux:       "1fa5340126d56b43eac06eadb71178cc531bee4a7ea0d9719b9f328947b6ccdf"
    sha256 cellar: :any, x86_64_linux:      "43568cf8a4d26cdf66bf64e45304a8215f7ce52942a8b9e571d748743ca72025"
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
