class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit/archive/v0.4.2.tar.gz"
  sha256 "d64ffb022f0f067433be9877d613995f6d97d6698b83a4c8b1243d05dd8ae4db"

  bottle do
    cellar :any
    sha256 "d723a4c29bed9ff97429264cd149cd7800841198d0a027137056f269b0c26f54" => :sierra
    sha256 "11bd0f49a62ee05b62cda24d3a0595695bcd6a5866c99e946862eb7d0cf9234a" => :el_capitan
    sha256 "57738db2b16a13a00ae95f86e3026a929ec253f2c763f6d4ddef186396aff2f7" => :yosemite
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
