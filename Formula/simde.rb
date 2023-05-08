class Simde < Formula
  desc "Implementations of SIMD intrinsics for systems which don't natively support them"
  homepage "https://github.com/simd-everywhere/simde"
  license "MIT"
  head "https://github.com/simd-everywhere/simde.git", branch: "master"

  stable do
    url "https://github.com/simd-everywhere/simde/archive/v0.7.4.tar.gz"
    sha256 "d5ae61b045cc8fd0ae84cbc70289721b0c0a4c9c5d7fe296bcb7673b0ea595e8"

    # build patch for https://github.com/simd-everywhere/simde/issues/1012
    # remove in next release
    patch do
      url "https://github.com/simd-everywhere/simde/commit/27836b19abf03886750a878fdacb1fcb7bcd9d85.patch?full_index=1"
      sha256 "fc09da2ffda17e79568bf582fdef085c08688550e2abe1536176bc6f7f84afb3"
    end

    # build patch for https://github.com/simd-everywhere/simde/issues/1012
    # remove in next release
    patch do
      url "https://github.com/simd-everywhere/simde/commit/f9cf4675d101eef2dd70dabbb4d6806b405eac29.patch?full_index=1"
      sha256 "a87475b391ebb48b0c19590eac60a1d65f327bb5d391591cafcdc57d9af0f0fa"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "173687e8a3088c99f7044df92c359fee930ab93f0d0708957c1ec359a29a348d"
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
