class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/3.2.3.tar.gz"
  sha256 "fe5e8c61ca5ea97975e231b1bb4a873d86e7908fdff416101c2a7cd13ecf5b41"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b4e56b60207e4f28fc1019267a15ed6573e2e6d794b45bae0c281eb9d11f5b5f"
    sha256 cellar: :any,                 arm64_monterey: "ababd7e8231c22a2e5a1b0f75d758595670cc27a1e8dd4269c101744a497c28b"
    sha256 cellar: :any,                 arm64_big_sur:  "f1da931db4dc7f1d3f2994e7163c42ef9c34d1f0a09f799733d95f3157f1b2d4"
    sha256 cellar: :any,                 ventura:        "6dcb51af4f431cc38dca8605ba8b15f2970c424c39beac8ee40dbb853985db63"
    sha256 cellar: :any,                 monterey:       "3d3d297d2fb5446dbc531e54bd57bd8affd5d92de5428731926b9abf319fe002"
    sha256 cellar: :any,                 big_sur:        "b9e82946bbd29e83d7ee6168cef7a92e231a18888483a8a531787304c8074506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087b495a5cf053a708c368b72ca10683b7730912e3bb91e402b8186f883d4a99"
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
