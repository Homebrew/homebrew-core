class Ulmblas < Formula
  desc "BLAS with micro kernels selected for the CPU at load time"
  homepage "https://github.com/michael-lehn/ulmBLAS"
  url "https://github.com/michael-lehn/ulmBLAS/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7b8f961438a00ddb35e258fba6322a249e9dc9d889831b454372cb0dd68883d2"
  license "BSD-3-Clause"

  depends_on "pkgconf" => :test

  on_macos do
    depends_on arch: :arm64
  end

  def install
    # the backends are built with their own -march/-mavx* flags and the
    # library selects one at load time
    ENV.runtime_cpu_detection
    ENV.O3
    # the compiler shim removes -mcpu: the SME backend with -march
    ENV["ARCHFLAGS_sme"] = "-march=armv9.2-a+sme2+sme-f64f64+nosve"
    ENV["ULMBLAS_VERSION"] = version.to_s
    ENV["ULMBLAS_INCLUDEDIR"] = include/"ulmblas"
    ENV["ULMBLAS_STATIC_LIBSTDCXX"] = "no"
    # BLAS only: LAPACK from the lapack formula
    ENV["FC"] = "none"
    ENV["MAKE"] = "make -j#{ENV.make_jobs}"
    system "sh", "interfaces/install-shared.sh", prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cblas.h>
      const char *ulmblas_backend(void);
      void dgemm_(const char *transA, const char *transB, const int *m,
                  const int *n, const int *k, const double *alpha,
                  const double *A, const int *ldA, const double *B,
                  const int *ldB, const double *beta, double *C,
                  const int *ldC);
      int main(void)
      {
          double A[4] = {1, 2, 3, 4}, B[4] = {1, 0, 0, 1}, C[4] = {0};
          double D[4] = {0}, one = 1, zero = 0;
          int two = 2;
          cblas_dgemm(CblasColMajor, CblasNoTrans, CblasNoTrans, 2, 2, 2,
                      1.0, A, 2, B, 2, 0.0, C, 2);
          dgemm_("N", "N", &two, &two, &two, &one, A, &two, B, &two, &zero,
                 D, &two);
          printf("%s %g %g %g %g\\n", ulmblas_backend(), C[0], C[1], C[2], C[3]);
          return !(C[0] == 1 && C[3] == 4 && D[1] == 2 && D[2] == 3);
      }
    C
    flags = shell_output("pkgconf --cflags --libs ulmblas").split
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
    # every backend the CPU can run
    backends = if OS.mac?
      %w[neon]
    elsif Hardware::CPU.intel?
      %w[generic sse3]
    else
      []
    end
    backends.each do |b|
      with_env(ULMBLAS_BACKEND: b) do
        assert_match b, shell_output("./test")
      end
    end
  end
end
