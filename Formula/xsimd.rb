class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.1.2.tar.gz"
  sha256 "58bf70a20d88325732de6f0a00198af63f55a12bca86a33ddd86e4fb145f4e21"

  bottle do
    cellar :any_skip_relocation
    sha256 "005309d1c8a751f481f873d12ca07662e0b053fd50923b4028359d9c09c324d5" => :mojave
    sha256 "b261f7a370c6e989b940ebb61b12aacc7c3576a96def9247e027587978b9871b" => :high_sierra
    sha256 "b261f7a370c6e989b940ebb61b12aacc7c3576a96def9247e027587978b9871b" => :sierra
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
