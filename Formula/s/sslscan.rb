class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.2.1.tar.gz"
  sha256 "188b94d99072727e8abd1439359611c18ea6983c2c535eaef726bbc2144c933d"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59eaeaf7377f2090db9387111e883e16afdb594416bf57345871b43a6e0fdd8f"
    sha256 cellar: :any,                 arm64_sequoia: "cad1744b76910e14241c1d7f4eee27069d316bbf57a62c763259e19f75bf759d"
    sha256 cellar: :any,                 arm64_sonoma:  "4aaece55b9e93aba34f28a2d0a90d9990f6ae515008801b936529b220ad6e9ef"
    sha256 cellar: :any,                 sonoma:        "4b8013ee4250f05a64bf02e63041debb13416b54c9be84de5559c05b981ce027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "636df179d6fff1c849f0ce0262fece31e37d7afb038f4d1eae541da989bc2217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf48ad55a6b3186ad74f4c4506487f8e0ca48b91f218c4a36e36d1b4bee3275"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system bin/"sslscan", "google.com"
  end
end
