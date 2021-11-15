class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/v2.1.4.tar.gz"
  sha256 "5583c70e97e4897bcac32ec487225c3e49161a7e2c8135d1d1a07e4be0375057"
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
