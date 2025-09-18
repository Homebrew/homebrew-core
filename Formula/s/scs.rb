class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/refs/tags/3.2.8.tar.gz"
  sha256 "22d2d785b7c7a9ee8a260d2684cf17ae4733271b8421fdbc78f281d19910ca1b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77d5bb4ffe72eeeb71080c6fb1216fd4e2e76bcc408f3455adb02a34f25dfe1c"
    sha256 cellar: :any,                 arm64_sequoia: "514d79f1514d65bb4f7c906c5119cc067cdcb6f488a4e02a4607404e67e9ec4a"
    sha256 cellar: :any,                 arm64_sonoma:  "fd30ac3374e2441ef5758e3da8cf452933eed2480a728c4a967f470cbd8df200"
    sha256 cellar: :any,                 arm64_ventura: "c0dfefb86022bbb38b8ef34d19ea8ff5ab8b8ba660ef974616e850e680ddaf74"
    sha256 cellar: :any,                 sonoma:        "c3d7d5d0401b1a903472bda4c95a350154399f24dcda766d074fc721578bf417"
    sha256 cellar: :any,                 ventura:       "4e3d96bef74189035d4286bf288b82d513e04a67de202c5629d099bf7b04d7a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd37b4230d757c543148777fd783368df5621b83409ba2e01b8d099f41a43029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6800d7ae52d671a4aa731b8f8c12baaa1354c213d173dbcc51139adcc2a3926e"
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
