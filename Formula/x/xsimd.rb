class Xsimd < Formula
  desc "Modern, portable C++ wrappers for SIMD intrinsics"
  homepage "https://xsimd.readthedocs.io/en/latest/"
  url "https://github.com/xtensor-stack/xsimd/archive/refs/tags/14.1.0.tar.gz"
  sha256 "8da77b66214e73565f6111ba494322c853552b7b40cff69779b42e2100eed16f"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc68cc93b73e54bedb85dd372f18b7f68de97f8bbdcbbd0db8d36b2a3fb3dc9a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <vector>
      #include <type_traits>

      #include "xsimd/config/xsimd_inline.hpp"
      #include "xsimd/memory/xsimd_alignment.hpp"

      using namespace xsimd;

      struct mock_container {};

      int main(void) {
        using u_vector_type = std::vector<double>;
        using a_vector_type = std::vector<double, xsimd::default_allocator<double>>;

        using u_vector_align = container_alignment_t<u_vector_type>;
        using a_vector_align = container_alignment_t<a_vector_type>;
        using mock_align = container_alignment_t<mock_container>;

        if(!std::is_same<u_vector_align, unaligned_mode>::value) abort();
        if(!std::is_same<a_vector_align, aligned_mode>::value) abort();
        if(!std::is_same<mock_align, unaligned_mode>::value) abort();
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-o", "test"
    system "./test"
  end
end
