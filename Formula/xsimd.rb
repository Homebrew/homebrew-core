class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/6.1.5.tar.gz"
  sha256 "ecc781520f7b2bfdeb51d1385683694f2e89be1a05b77b222b9783cfeb645034"

  bottle do
    cellar :any_skip_relocation
    sha256 "45dd6378d60d276d7071333b5fd2a787c54d164488d478654c15538c57a6796e" => :high_sierra
    sha256 "45dd6378d60d276d7071333b5fd2a787c54d164488d478654c15538c57a6796e" => :sierra
    sha256 "45dd6378d60d276d7071333b5fd2a787c54d164488d478654c15538c57a6796e" => :el_capitan
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
