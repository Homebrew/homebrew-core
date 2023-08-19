class Simde < Formula
  desc "Implementations of SIMD intrinsics for systems which don't natively support them"
  homepage "https://github.com/simd-everywhere/simde"
  url "https://github.com/simd-everywhere/simde/archive/v0.7.6.tar.gz"
  sha256 "c63e6c61392e324728da1c7e5de308cb31410908993a769594f5e21ff8de962b"
  license "MIT"
  head "https://github.com/simd-everywhere/simde.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e236c17b7eb174dbefb648865412d7b59263447f4161fb92fe13fa383b42fbab"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dtests=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <simde/arm/neon.h>
      #include <simde/x86/sse2.h>

      int main() {
        int64_t a = 1, b = 2;
        assert(simde_vaddd_s64(a, b) == 3);
        simde__m128i z = simde_mm_setzero_si128();
        simde__m128i v = simde_mm_undefined_si128();
        v = simde_mm_xor_si128(v, v);
        assert(simde_mm_movemask_epi8(simde_mm_cmpeq_epi8(v, z)) == 0xFFFF);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
