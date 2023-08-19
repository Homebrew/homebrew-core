class Sse2neon < Formula
  desc "Translator from Intel SSE intrinsics to Arm/Aarch64 NEON implementation"
  homepage "https://github.com/DLTcollab/sse2neon"
  url "https://github.com/DLTcollab/sse2neon/archive/v1.6.0.tar.gz"
  sha256 "06f4693219deccb91b457135d836fc514a1c0a57e9fa66b143982901d2d19677"
  license "MIT"
  head "https://github.com/DLTcollab/sse2neon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "485a6235165d9415b6996665721102846c8787b5f7c6588bc2f494821b6c287a"
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
