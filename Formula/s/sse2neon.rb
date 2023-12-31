class Sse2neon < Formula
  desc "Translator from Intel SSE intrinsics to Arm/Aarch64 NEON implementation"
  homepage "https://github.com/DLTcollab/sse2neon"
  url "https://github.com/DLTcollab/sse2neon/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "cee6d54922dbc9d4fa57749e3e4b46161b7f435a22e592db9da008051806812a"
  license "MIT"
  head "https://github.com/DLTcollab/sse2neon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3606b905406ef9d76f07277db5c46e96d6a6372e55b61aa195684859cb6801b3"
  end

  depends_on arch: :arm64

  def install
    include.install "sse2neon.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <sse2neon.h>

      int main() {
        int64_t a = 1, b = 2;
        assert(vaddd_s64(a, b) == 3);
        __m128i z = _mm_setzero_si128();
        __m128i v = _mm_undefined_si128();
        v = _mm_xor_si128(v, v);
        assert(_mm_movemask_epi8(_mm_cmpeq_epi8(v, z)) == 0xFFFF);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
