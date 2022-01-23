class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/3.1.0.tar.gz"
  sha256 "90a7e58364ed3ea3375945a7f6f013de81c46100df80664a18f1c9b45a56be9c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "7396232a2441de245f2833b8b1503a9ccb892ba74d32a0fe791aec30a3f2950a"
    sha256 cellar: :any,                 arm64_big_sur:  "1e0d76bd37e43f488204b8601b3d2d34cfb6bdac82ee1c0f9d326ca06b14b1a4"
    sha256 cellar: :any,                 monterey:       "77ed8f0663cfa9f7784a75481115d10342fed9f3e6b701cdb71bb38d4ad6ebeb"
    sha256 cellar: :any,                 big_sur:        "5956182473063c3d2e47270913d4d007545ac06b03b14889dcf0393579882639"
    sha256 cellar: :any,                 catalina:       "f4bb9a6a92cf7fbdae23f4cc939c89b39d0bd8c2dfb55eb179805a7e94446a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d905ace10ceac5e2e8137afb6cdfe09c4c9dd8d920b0a9377836de182447a9"
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

        _scs_free_data(d, k, stgs); _scs_free_sol(sol);
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
