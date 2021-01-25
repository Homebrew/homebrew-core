class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.4.9.tar.gz"
  sha256 "f6601ffb002864ec0dc6013efd9f7a72d756418857c2d893be0644a2f041874e"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d648aebe105458dff109f168583737d4be1f60f00905c84961383ee1f3e5574" => :big_sur
    sha256 "5cbab32bef8f9b7d81da2d109e7a72fbc73657335ca26c3be423ef8fc1e518f2" => :arm64_big_sur
    sha256 "683112b939a02c0a8bd76f8e9a2e623d50a24bc4775b9e8dcfa1a6f750ad904b" => :catalina
    sha256 "3144366e8952b3c158eaec803eac46ad3dcf55ca7b5ba5dea3a3418922ef5f4e" => :mojave
    sha256 "355cbbb72b037b406eb9ca4600e446958368bd61b8cedb7abeea81f08b5c5c7b" => :high_sierra
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
