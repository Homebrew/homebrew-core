class Sse2neon < Formula
  desc "Translator from Intel SSE intrinsics to Arm/Aarch64 NEON implementation"
  homepage "https://github.com/DLTcollab/sse2neon"
  url "https://github.com/DLTcollab/sse2neon/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "6b70e7cb8c5ce4641002b85deaafe97efdf9ade9b49884edeaf678b35f0e132f"
  license "MIT"
  head "https://github.com/DLTcollab/sse2neon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46cf8773ecb867115c8cdef988d4eb9a928e6f0c0e45cb5513b00603cab0bddd"
  end

  depends_on arch: :arm64

  def install
    (include/"sse2neon").install "sse2neon.h"
    include.install_symlink "sse2neon/sse2neon.h"
  end

  test do
    %w[sse2neon sse2neon/sse2neon].each do |include_path|
      test_name = include_path.tr("/", "-")
      (testpath/"#{test_name}.c").write <<~C
        #include <assert.h>
        #include <#{include_path}.h>

        int main() {
          int64_t a = 1, b = 2;
          assert(vaddd_s64(a, b) == 3);
          __m128i z = _mm_setzero_si128();
          __m128i v = _mm_undefined_si128();
          v = _mm_xor_si128(v, v);
          assert(_mm_movemask_epi8(_mm_cmpeq_epi8(v, z)) == 0xFFFF);
          return 0;
        }
      C

      system ENV.cc, "#{test_name}.c", "-o", test_name
      system testpath/test_name
    end
  end
end
