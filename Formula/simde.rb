class Simde < Formula
  desc "Implementations of SIMD intrinsics for systems which don't natively support them"
  homepage "https://github.com/simd-everywhere/simde"
  url "https://github.com/simd-everywhere/simde/archive/v0.7.2.tar.gz"
  sha256 "366d5e9a342c30f1e40d1234656fb49af5ee35590aaf53b3c79b2afb906ed4c8"
  license "MIT"
  head "https://github.com/simd-everywhere/simde.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b76aa4bfc8e2fe4c0af7a594e7f25aba0575b4f0ca9babef7057215e9cafe74"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir("build") do
      system "meson", *std_meson_args, "-Dtests=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
