class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit/archive/v0.4.4.tar.gz"
  sha256 "6bed356efb834519a9c3d5eaa4891465ccfaa92c5e5cad9dd125baf537c54b08"

  bottle do
    cellar :any
    sha256 "0ee982c44e53a11f8e1ab177847a732c306d0c803871779bb2d525af797158bb" => :sierra
    sha256 "9e9f36d267ce2670ddb685b8bdb376284884f94582fbdc5e900981dbf3f07c06" => :el_capitan
    sha256 "72e02cf0e1220f68055fcc7c062ac37fe9c0f7897a238f3b8c601da96bd1c6ff" => :yosemite
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
