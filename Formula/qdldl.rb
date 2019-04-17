class Qdldl < Formula
  desc "Free LDL factorisation routine for quasi-definite linear systems"
  homepage "https://github.com/oxfordcontrol/qdldl"
  url "https://github.com/oxfordcontrol/qdldl/archive/v0.1.3.tar.gz"
  sha256 "a2c3a7d0c6a48b2fab7400fa8ca72a34fb1e3a19964b281c73564178f97afe54"
  head "https://github.com/oxfordcontrol/qdldl.git"

  depends_on "cmake" => [:build, :test]

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
      project(qdldl_test LANGUAGES C)
      find_package(qdldl CONFIG REQUIRED)
      add_executable(qdldl_test test.c)
      target_link_libraries(qdldl_test PRIVATE qdldl::qdldl)
    EOS
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <qdldl.h>
      int main() {
        const QDLDL_int An = 10;
        const QDLDL_int Ap[] = {0, 1, 2, 4, 5, 6, 8, 10, 12, 14, 17};
        const QDLDL_int Ai[] = {0, 1, 1, 2, 3, 4, 1, 5, 0, 6, 3, 7, 6, 8, 1, 2, 9};
        QDLDL_int *iwork = (QDLDL_int *)calloc(3 * An, sizeof(QDLDL_int));
        QDLDL_int *Lnz = (QDLDL_int *)calloc(An, sizeof(QDLDL_int));
        QDLDL_int *etree = (QDLDL_int *)calloc(An, sizeof(QDLDL_int));
        QDLDL_int sumLnz = 0;
        const QDLDL_float Ax[] = {1.0, 0.460641, -0.121189, 0.417928, 0.177828,
          0.1, -0.0290058, -1.0, 0.350321, -0.441092, -0.0845395, -0.316228,
          0.178663, -0.299077, 0.182452, -1.56506, -0.1};
        QDLDL_int *Lp = (QDLDL_int *)calloc(An + 1, sizeof(QDLDL_int));
        QDLDL_int *Li;
        QDLDL_float *Lx;
        QDLDL_float *D = (QDLDL_float *)calloc(An, sizeof(QDLDL_float));
        QDLDL_float *Dinv = (QDLDL_float *)calloc(An, sizeof(QDLDL_float));
        QDLDL_bool *bwork = (QDLDL_bool *)calloc(An, sizeof(QDLDL_bool));
        QDLDL_float *fwork = (QDLDL_float *)calloc(An, sizeof(QDLDL_float));
        QDLDL_float *x = (QDLDL_float *)calloc(An, sizeof(QDLDL_float));
        QDLDL_int i = 0;
        const QDLDL_int Ln = An;
        const QDLDL_float b[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0};
        sumLnz = QDLDL_etree(An, Ap, Ai, iwork, Lnz, etree);
        Li = (QDLDL_int *)calloc(sumLnz, sizeof(QDLDL_int));
        Lx = (QDLDL_float *)calloc(sumLnz, sizeof(QDLDL_float));
        QDLDL_factor(An, Ap, Ai, Ax, Lp, Li, Lx, D, Dinv, Lnz, etree, bwork,
          iwork, fwork);
        for (i = 0; i < Ln; ++i) x[i] = b[i];
        QDLDL_solve(Ln, Lp, Li, Lx, Dinv, x);
        free(x);
        free(fwork);
        free(bwork);
        free(Dinv);
        free(D);
        free(Lx);
        free(Li);
        free(Lp);
        free(etree);
        free(Lnz);
        free(iwork);
        return 0;
      }
    EOS
    system "cmake", "."
    system "make"
    system "./qdldl_test"
  end
end
