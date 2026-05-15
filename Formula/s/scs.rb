class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/refs/tags/3.2.11.tar.gz"
  sha256 "ceb5d9ecf35836ee7e0ce64566190f11a99314ec8143dbb909329809afa3f77f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a8a0ccadf4efdd208dbb6c465e8589c7f92db0eaaba81cbb9a8325ed8a56279"
    sha256 cellar: :any,                 arm64_sequoia: "0bb1ba6d070cf3acf1e1d29b8e21a48ee676a16ed2813c2419800a40e8d6c08d"
    sha256 cellar: :any,                 arm64_sonoma:  "71971bff69af127a73bda3a5f320e0270217be8efa26ff4c2148507858308bff"
    sha256 cellar: :any,                 sonoma:        "335a47718a3368a24425f8a38f7824ddd369afd79c05b9396d8b6e9cdbb3d12b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e798c3ebcdfbb3650414059e3189cbecbd1ad26e6f3a5a6a3109be14ca97e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ef44e6427596c2b80d33b94f6373dfafb51c951d808d01a06dc5797874147b"
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
