class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.2.5.tar.gz"
  sha256 "15ddcb3e61352d905b6a0179a2e88bf3b892e0bc724e23d5e0591449239dc891"

  bottle do
    cellar :any_skip_relocation
    sha256 "78987411aeded50d92ee15d5298e4f3f4abb6a6681a73a5c5ed18e680e5a8e11" => :mojave
    sha256 "78987411aeded50d92ee15d5298e4f3f4abb6a6681a73a5c5ed18e680e5a8e11" => :high_sierra
    sha256 "1d80baa80a9f1c61f8121d56a25c7598f3ae6217c8b85d31e02ca86abfa41bd9" => :sierra
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
