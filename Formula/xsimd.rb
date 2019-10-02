class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.4.1.tar.gz"
  sha256 "787b6c8b202d2d34d78335549bfc09f2268218e5923c2d463ab8ad6d691e5d63"

  bottle do
    cellar :any_skip_relocation
    sha256 "9648408a25af8d9781923ece9c2457f2c52cb0a011493dcb2d0200a6a6ad66ff" => :catalina
    sha256 "9648408a25af8d9781923ece9c2457f2c52cb0a011493dcb2d0200a6a6ad66ff" => :mojave
    sha256 "9648408a25af8d9781923ece9c2457f2c52cb0a011493dcb2d0200a6a6ad66ff" => :high_sierra
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
