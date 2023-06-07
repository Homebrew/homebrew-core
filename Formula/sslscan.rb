class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.16.tar.gz"
  sha256 "eae49b9c2023f9c9adeb10c50a6ee3ddf5da7aae20f6a6c59251e7a84aa44131"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00e42463d95e3f313739201c50333b42402c4dd0b7a3d1ef3d25f606664579a0"
    sha256 cellar: :any,                 arm64_monterey: "6dc1042fbb94d391189896b4cdc49d1ec00f5cff7b8ae8055f90031b84935ce4"
    sha256 cellar: :any,                 arm64_big_sur:  "2af57be0dd15e2fb264a217f7f210f7771044be711eada8545da6e81d27e2055"
    sha256 cellar: :any,                 ventura:        "c1d231b03d7a64cbf8f9196042939403cd4abef7ac57b6546b8f9d678b4be67a"
    sha256 cellar: :any,                 monterey:       "756df8dec2d82f9b6ab2199c98be064b1b7153786741505cd1f4b4ab2370f768"
    sha256 cellar: :any,                 big_sur:        "c5004f11134e7a6ac1cf724bd8535844b4d934a35bbec78501cadc737cc134e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76521cd1626682568227bedb8ed2c495d12d89c5d3aabfbbbcd80dae14c00d37"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
