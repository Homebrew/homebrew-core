class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/v2.1.3.tar.gz"
  sha256 "cb139aa8a53b8f6a7f2bacec4315b449ce366ec80b328e823efbaab56c847d20"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "31f24806066b7875a7f95449334dc87db7469a8e9bf16e6e3af2e08477a7a18c"
    sha256 cellar: :any, big_sur:       "02a9439a63388387cde336365b7fa8ce72dee8b007cb5b4738187cc3d8450d15"
    sha256 cellar: :any, catalina:      "9557d174fd285c18d2196035dad66ad22781727da8ee450d2a1c6a8a591ade72"
    sha256 cellar: :any, mojave:        "8a0b90a351d6f54549b6aca70f3a19353bf33732d15cbcdb827962bed0f0cc52"
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
