class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.11/xapian-core-1.4.11.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.11.tar.xz"
  sha256 "9f16b2f3e2351a24034d7636f73566ab74c3f0729e9e0492934e956b25c5bc07"

  bottle do
    cellar :any
    rebuild 1
    sha256 "424ac432e892cfc455f6fcd8ae7608b44d76d39a73361b3b56d143ac30921b8c" => :mojave
    sha256 "32e3b96b619d8f39e6f2d5a32fb0f9b9fb0e1378fcfdbb2a163eb549798e10e1" => :high_sierra
    sha256 "adfbefe2380111b93f1ebce01311bf8a1d07f91715e90b33134457604772d41d" => :sierra
  end

  skip_clean :la

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xapian-config", "--libs"
  end
end
