class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.12.1.tar.gz"
  sha256 "5477c08d4e1d062f164c2e486a83556925d07d70f2180de706af7aa949c6ff5c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01d1ac07f4a1bf163dcbfd6ae3afe55e043fae1e0d1fc962ff1f09a9e03d8c1b"
    sha256 cellar: :any,                 arm64_sonoma:  "ed49be41281df5dd496cade6dd2c8ff4ee1d3b643f5d3a62d89680e7ae227790"
    sha256 cellar: :any,                 arm64_ventura: "0d50f5e1859224e180115300d041298bd456f7e13b661f48129e3525d8c24773"
    sha256 cellar: :any,                 sonoma:        "7e8da640c93b94394c0e83b0566e97d328499748c29e9afd944fb0f7cacfbf23"
    sha256 cellar: :any,                 ventura:       "310fe4d8351581ae79291aa7fab20af5fc9db374324133363f98db39c2f439f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf4d03cbb661f19e3c654305363fe7209982b24896ca63ac421789c8d6e9724"
  end

  depends_on "python@3.12" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    randltl_output = pipe_output("#{bin}/randltl -n20 a b c d", "")
    assert_match "Xb R ((Gb R c) W d)", randltl_output

    ltlcross_output = pipe_output("#{bin}/ltlcross '#{bin}/ltl2tgba -H -D %f >%O' " \
                                  "'#{bin}/ltl2tgba -s %f >%O' '#{bin}/ltl2tgba -DP %f >%O' 2>&1", randltl_output)
    assert_match "No problem detected", ltlcross_output
  end
end
