class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit/archive/v0.4.5.tar.gz"
  sha256 "ac013b5a02d250450c983a3efc0997f2a5f5675bc3e16b51ed0a54dff1caef7c"

  bottle do
    cellar :any
    sha256 "cd025199fe0e5400355a7f18e9b49dc1a6726ec0479a02bf9d55b57087796f77" => :sierra
    sha256 "bba9db5b2cca6916fade1d258b98f349532eeb85b39c4b3879125a0a96bb0ecd" => :el_capitan
    sha256 "200efba13f31b9632ff2d6b8622e9a80965d94d02eb5178850c52105ff0fe517" => :yosemite
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
