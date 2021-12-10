class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/v3.0.0.tar.gz"
  sha256 "95ab61495db72b18d6bb690cd2ae2ce88134d078c473da6cb8750857ea17f732"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "d28c5e038575f7c2cff097c87672144ba168787ac856a1ecbb55883cd7d36986"
    sha256 cellar: :any, arm64_big_sur:  "1ed24f3a880440b3942c883f8185ec1e700af91c9c0884a4d063c4aca033b601"
    sha256 cellar: :any, monterey:       "7f9d443d83f84b7ed2694e72f1a6a63238d5b802063e3cbe2f332f1e4ab83af6"
    sha256 cellar: :any, big_sur:        "4d233014f4bc6fdcabf67539f529db91ada67bde50d81135b9ad341593f16603"
    sha256 cellar: :any, catalina:       "299e64e7238afb223b721ca1586d168128f6981432058f6f76e766954f1fee5f"
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
