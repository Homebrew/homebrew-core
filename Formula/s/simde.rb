class Simde < Formula
  desc "Implementations of SIMD intrinsics for systems which don't natively support them"
  homepage "https://github.com/simd-everywhere/simde"
  url "https://github.com/simd-everywhere/simde/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d7c1aef6dd9ef0fbe6f521d1ca3e79afc26deda7d8f857544ca020b42a4b9b97"
  license "MIT"
  head "https://github.com/simd-everywhere/simde.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e236c17b7eb174dbefb648865412d7b59263447f4161fb92fe13fa383b42fbab"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  # Patches iterated on via https://github.com/simd-everywhere/simde/issues/1146
  patch do
    url "https://github.com/simd-everywhere/simde/commit/21db6433cece8ed0ddb2e52c018f7a24ddbb6af4.patch?full_index=1"
    sha256 "85bf378fcf9a419ef9f0636c90d57e678e3169b7cef9180295217645b93876c4"
  end

  patch do
    url "https://github.com/simd-everywhere/simde/commit/26b55a9b3ea26301b07880a941a5deaf783602a1.patch?full_index=1"
    sha256 "4790f2444eacedf88686c6a1ee30889e06ca54aff5368f831af1715a3a9b1c83"
  end

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
