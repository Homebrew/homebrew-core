class Simde < Formula
  desc "Implementations of SIMD intrinsics for systems which don't natively support them"
  homepage "https://github.com/simd-everywhere/simde"
  url "https://github.com/simd-everywhere/simde/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "ed2a3268658f2f2a9b5367628a85ccd4cf9516460ed8604eed369653d49b25fb"
  license "MIT"
  head "https://github.com/simd-everywhere/simde.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8ffb9243611a027320542a403fbcc1d2f7f45516484d44ec5a0fae570b2f7892"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dtests=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
