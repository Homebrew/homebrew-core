class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.7.1.tar.gz"
  sha256 "e4a38fbab23ab17a8f10423f9c08153c2bdd7eaadc9251f9d5167eaf0642e9c7"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a95e46a0bda987b08eb01064dc789e5abb42df9ad36ae09a6029610583a973bb"
    sha256 cellar: :any, arm64_sequoia: "7a60faf46d6bbcf07fdf3ab0bd8e9794731a291ea282aed1e72485dabc537634"
    sha256 cellar: :any, arm64_sonoma:  "893df7d013f055d8af80d5c22c8c637deb312acd8859f9941ded35927a6ba089"
    sha256 cellar: :any, sonoma:        "b916d0e89bede0fe3d507cdb65424734251bbe2df4fbcce32e0d35ce9f262182"
    sha256 cellar: :any, arm64_linux:   "98738d3608e62a50c05abf389e57da558757a51fcf19cda38ffbeed2dc3e8408"
    sha256 cellar: :any, x86_64_linux:  "9e7b5082b0fe61e199d0aface66f1fdcfc339b6ac5e8b4299be6928cb5167e4e"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libidn2"
  depends_on "libmaxminddb"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      Address        = 1.1.1.1
                          \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network        = 1.1.1.1 / 32
      Netmask        = 255.255.255.255
      Broadcast      = not needed on Point-to-Point links
      Wildcard Mask  = 0.0.0.0
      Hex. Address   = 01010101
      Host Bits      = 0
      Max. Hosts     = 1   (2^0 - 0)
      Host Range     = { 1.1.1.1 - 1.1.1.1 }
      Properties     = \

         - 1.1.1.1 is a HOST address in 1.1.1.1/32
         - Class A
      DNS Hostname   = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end
