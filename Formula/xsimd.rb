class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.1.1.tar.gz"
  sha256 "0ae5c399f74bcef87d5bcbd97bfd52da4c6d46bd0b146c589f5cf0b98f28d828"

  bottle do
    cellar :any_skip_relocation
    sha256 "8320a8b27a49022994e6aa3e232dd4eac15959e480ab53b439bc29de2479e848" => :mojave
    sha256 "f247253fcfc8a4fdd582bb1142ca472472c0c5ebeb9c16bf738acccd830b53c3" => :high_sierra
    sha256 "f247253fcfc8a4fdd582bb1142ca472472c0c5ebeb9c16bf738acccd830b53c3" => :sierra
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
