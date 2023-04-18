class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.4.21.tar.gz"
  sha256 "43b5c162496529238e4261ac8f562f04965b4ee1956c508b6c1c78c7e7cc3ca2"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "448c9a4cfd16b74b5d5736a9f79c41561a7a4ea64dc8aec70dc79be5dceed1a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c43c3b341d1bccad74159860507d69fdd987c88c5bcb40a43ddd263804bdee55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fea19e5ea9b50c64964eea89d42cab6e73226a84edf902312d075e4221a024d4"
    sha256 cellar: :any_skip_relocation, ventura:        "c4f1ea6cb8dc466cfe374dfe1c58e7e740c5c55d6c08c601fc8a787c995c4807"
    sha256 cellar: :any_skip_relocation, monterey:       "041126a8a260f2be6a214276e300fb2ab1e50be90401b0c1e4c78d9f8ba7ad02"
    sha256 cellar: :any_skip_relocation, big_sur:        "b74f11d72ddcdc25c3c6335681d0a42b6f234c8151517d835d41848f32bbac03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e71dab73f979672019fb1aee85c4dbc38f6be8183355b3e9b14a95b465719295"
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    expected = <<~EOS
      Address       = 1.1.1.1
                         \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network       = 1.1.1.1 / 32
      Netmask       = 255.255.255.255
      Broadcast     = not needed on Point-to-Point links
      Wildcard Mask = 0.0.0.0
      Hosts Bits    = 0
      Max. Hosts    = 1   (2^0 - 0)
      Host Range    = { 1.1.1.1 - 1.1.1.1 }
      Properties    =
         - 1.1.1.1 is a NETWORK address
         - Class A
      Performing reverse DNS lookup ...\r\e[KDNS Hostname  = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end
