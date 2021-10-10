class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/v3.0.0.tar.gz"
  sha256 "95ab61495db72b18d6bb690cd2ae2ce88134d078c473da6cb8750857ea17f732"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "314ba6c1d1f05470bdb444d392083c2989cd6391bc525f53d719e5b5f7cd17d8"
    sha256 cellar: :any, arm64_big_sur:  "fdbe71dc5aff701be00e9629c5ee27cdf0d5942aebea202da39a78217569097e"
    sha256 cellar: :any, monterey:       "6555694ae2fdca5f72009c124eb7f801ed45bd9b9fdc05945fe9a92bcfaa3308"
    sha256 cellar: :any, big_sur:        "1d41b23aceb11793eb5fed5caa703818f62636ae23e70134ae064a4d829f59d0"
    sha256 cellar: :any, catalina:       "37e188ea7df7a55ee087a32743bfce52cdb0acd91ddcffff629659f3c6a326bc"
    sha256 cellar: :any, mojave:         "99764bf3362d0dd01f78337f1f943e77b48d68ffc8ef18fffa811516f9763e4f"
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

        scs_read_data("#{pkgshare}/random_prob", &d, &k, &stgs);
        result = scs(d, k, stgs, sol, &info);

        scs_free_data(d, k, stgs); scs_free_sol(sol);
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
