class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xsimd/archive/7.1.0.tar.gz"
  sha256 "a7dfed9add408195e0aed617ba5aaefe9f701080eb49f66ef6e2308736250f6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a24ffc89649331370da9175f0cbbc0a7994ab6c9719a14c417b823e9c71606dd" => :mojave
    sha256 "ec4ea29cee3b00e25067916fbbd54bec16e07a8a5fc5ff25ccfb4745b587575d" => :high_sierra
    sha256 "ec4ea29cee3b00e25067916fbbd54bec16e07a8a5fc5ff25ccfb4745b587575d" => :sierra
    sha256 "ec4ea29cee3b00e25067916fbbd54bec16e07a8a5fc5ff25ccfb4745b587575d" => :el_capitan
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
