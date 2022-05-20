class Sse2neon < Formula
  desc "Translator from Intel SSE intrinsics to Arm/Aarch64 NEON implementation"
  homepage "https://github.com/DLTcollab/sse2neon"
  url "https://github.com/DLTcollab/sse2neon/archive/v1.5.1.tar.gz"
  sha256 "4001e2dfb14fcf3831211581ed83bcc83cf6a3a69f638dcbaa899044a351bb2a"
  license "MIT"
  head "https://github.com/DLTcollab/sse2neon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b693ec3aa8d6dc9c6ea07d4abae801b34c5d884585453ae3ddc5a0ee87ed3577"
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
