class Urbit < Formula
  desc "Personal cloud computer"
  homepage "https://urbit.org"
  url "https://github.com/urbit/urbit/archive/v0.4.tar.gz"
  sha256 "7320a3099b5a6392a6860f6824bb4b575bbde19ff1f59bc4661b3dbb9d1fbc69"

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
