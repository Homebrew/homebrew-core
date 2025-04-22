class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/refs/tags/3.2.7.tar.gz"
  sha256 "bc8211cfd213f3117676ceb7842f4ed8a3bc7ed9625c4238cc7d83f666e22cc9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6c51a4ad4ca92b9a9dc0484ea9c4f9b6322ce88e6ad236881a2b14dbf0423e7b"
    sha256 cellar: :any,                 arm64_sonoma:   "01c9ae089993b4415924308e126012b86327100bdaa9146c0aee08a9865a8c42"
    sha256 cellar: :any,                 arm64_ventura:  "d598a72de7867bfa376e0ebff3dd2c3bbb0f6e027e1c7cdc7450655e5d0e3fd9"
    sha256 cellar: :any,                 arm64_monterey: "ede06b46c1681c4fd1b78a73609c93b2447d715a9c10a2dad288a13fd251c2b6"
    sha256 cellar: :any,                 sonoma:         "61eca2394f08be31933544ad01b9dc62d2ed9f8a7a1eb4aae413b0ecbc1e038d"
    sha256 cellar: :any,                 ventura:        "305266e59644b836bfc848d6feafc1b5889d67eb751e662bf1a2be8a2b4e55cb"
    sha256 cellar: :any,                 monterey:       "102c6c90dd8a1ef3b66cbcf326e71226f06a2853791448747a636896a9662dd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b52b621aa59fa13789329aba8c51102188a148e9b15165d2d9698b9d9e3423b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4351ced8c3f4b299d6e7f91d599f545cffc321f49c306ba45727b61e244ae42"
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
