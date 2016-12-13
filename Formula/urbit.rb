class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit/archive/v0.4.2.tar.gz"
  sha256 "d64ffb022f0f067433be9877d613995f6d97d6698b83a4c8b1243d05dd8ae4db"

  bottle do
    cellar :any
    sha256 "8cfa835171cddaca78fe33b173b0d8046276b6ea517f5b5cf85722be2005880e" => :sierra
    sha256 "3e2391cff7e0689176338e49427988fdde52037132b30f56c56af79ec85a5c58" => :el_capitan
    sha256 "3b317f4b178acde0ed429aab7867d94a60551d74d5aea1e4119b2f54682a1eef" => :yosemite
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
