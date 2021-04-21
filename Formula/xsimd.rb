class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.5.0.tar.gz"
  sha256 "45337317c7f238fe0d64bb5d5418d264a427efc53400ddf8e6a964b6bcb31ce9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c63ea8911c5fc1df0a68893f4611be0550cf3c877004ce4ec86e6e858634995a"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa6998d360357803e3eb73aa4140d2610f0c0aacd0f88468ae8c8956c44106c2"
    sha256 cellar: :any_skip_relocation, catalina:      "332df0f1f0266c305be2d776a617bb0a6594c641c85b2ff96f9223acd8487f9f"
    sha256 cellar: :any_skip_relocation, mojave:        "ae39c2f9ab6c9107917a3da3b3a30ab15e51e77d4758255301d2c787d8650bd3"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTS=OFF"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vector>
      #include <type_traits>

      #include "xsimd/memory/xsimd_alignment.hpp"

      using namespace xsimd;

      struct mock_container {};

      int main(void) {
        using u_vector_type = std::vector<double>;
        using a_vector_type = std::vector<double, aligned_allocator<double, XSIMD_DEFAULT_ALIGNMENT>>;

        using u_vector_align = container_alignment_t<u_vector_type>;
        using a_vector_align = container_alignment_t<a_vector_type>;
        using mock_align = container_alignment_t<mock_container>;

        if(!std::is_same<u_vector_align, unaligned_mode>::value) abort();
        if(!std::is_same<a_vector_align, aligned_mode>::value) abort();
        if(!std::is_same<mock_align, unaligned_mode>::value) abort();
        return 0;
      }
    EOS
    system ENV.cxx, "test.c", "-std=c++14", "-I#{include}", "-o", "test"
    system "./test"
  end
end
