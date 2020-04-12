class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.4.7.tar.gz"
  sha256 "392278c210592350096ef77c97d8ad3c311c879e910e44de328a122b9e5afed5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0f2aad9ec3ebcd54a8feac2a1c1b365f1429930e4e64f46acb8fc6f62d66741" => :catalina
    sha256 "f0f2aad9ec3ebcd54a8feac2a1c1b365f1429930e4e64f46acb8fc6f62d66741" => :mojave
    sha256 "f0f2aad9ec3ebcd54a8feac2a1c1b365f1429930e4e64f46acb8fc6f62d66741" => :high_sierra
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
