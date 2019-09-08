class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.3.0.tar.gz"
  sha256 "208b09d9056593460b2f87c5ad20f3d9e000b6306995c7672ea23c1b4a2fd616"

  bottle do
    cellar :any_skip_relocation
    sha256 "030dd275d7b0ff77a8eefeffb947f805d753a6dd25152c98a0b37a7f463ce1b5" => :mojave
    sha256 "030dd275d7b0ff77a8eefeffb947f805d753a6dd25152c98a0b37a7f463ce1b5" => :high_sierra
    sha256 "74e65077d89c107d9b5f0d9de6b177eef23ce63274c5899d0015bbf4dffd3ff8" => :sierra
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
