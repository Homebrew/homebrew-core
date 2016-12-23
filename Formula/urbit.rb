class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit/archive/v0.4.4.tar.gz"
  sha256 "6bed356efb834519a9c3d5eaa4891465ccfaa92c5e5cad9dd125baf537c54b08"

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
