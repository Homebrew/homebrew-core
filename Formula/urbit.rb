class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit/archive/v0.4.5.tar.gz"
  sha256 "ac013b5a02d250450c983a3efc0997f2a5f5675bc3e16b51ed0a54dff1caef7c"

  bottle do
    cellar :any
    sha256 "6aa8484fbfaa20cd2b2b53b8de1cea7b342fe2a34185a91a680d6d544ac93d1f" => :sierra
    sha256 "fa9109dff4cde264e6581f81e9bd30574081fd94ebff4436888d77460db4b8ad" => :el_capitan
    sha256 "5544b9553137481df6e2035a4e0a0b022f362fab12f2b3047cc206a93f79cc5c" => :yosemite
  end

  depends_on "gmp"
  depends_on "libsigsegv"
  depends_on "openssl"

  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build

  def install
    system "make", "BIN=#{bin}", "LIB=#{share}"
  end

  test do
    assert_match "simple usage:", shell_output("#{bin}/urbit 2>&1", 1)
  end
end
