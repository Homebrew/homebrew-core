class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/refs/tags/3.2.6.tar.gz"
  sha256 "70b5423a6c1cce4fa510f1746803cb0922c51c88c1a9ad8bdb55c3537777bac2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6469caa79ebf81c3d6cc8bb61bd2689015fbed5462ad7eaf24343024457700b7"
    sha256 cellar: :any,                 arm64_ventura:  "20c48fd864219e537a6d20689726f05c6a62338af960d085a5c1f8c918e78710"
    sha256 cellar: :any,                 arm64_monterey: "b543b0124d90071756f4a594cb911f84de42ffbc24654a6ab0cfa16515d9ffc3"
    sha256 cellar: :any,                 sonoma:         "fc2336c918874594c36d558bbd65942e891feb1af2be4825e885f730c31669b5"
    sha256 cellar: :any,                 ventura:        "f35c1c3381b7fb5870105a90a6bdc6837d49bcf9919b3690cd174bfbf649aa57"
    sha256 cellar: :any,                 monterey:       "46fc788b42d9eb43470f5036652b0c1fa305cb7e91d042397d84c5a53807c159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86853a520c05d3eebaa384c867b18456f32c74ac52b3232e0e9f11977d38160e"
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
