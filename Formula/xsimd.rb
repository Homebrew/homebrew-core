class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.4.0.tar.gz"
  sha256 "466954041cf4a7ad8574926df73425d2b8fe1d5f2dafbf489217378e9c13c0d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "edc1cd2a23ac07ade0fe57c6f2e947108cd5a228e67c8fb87ce9283cf5096e9c" => :mojave
    sha256 "edc1cd2a23ac07ade0fe57c6f2e947108cd5a228e67c8fb87ce9283cf5096e9c" => :high_sierra
    sha256 "853763a2dee53da192c8161dcd353be2df7ff445527b4cc894d8817f94afdd9c" => :sierra
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
