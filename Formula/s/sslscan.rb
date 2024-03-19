class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.1.3.tar.gz"
  sha256 "6beec9345635b41fa2c1bbc5f0854f10014e4b2b4179e9e9a3bda6bdb9e1aa41"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a7d694ec82b51f49b4f164f54f192d08060af88ab38cc007d8c4e2611347424"
    sha256 cellar: :any,                 arm64_ventura:  "a4b03c80448b277021a4d90a62f9318375410939e2cb8d956f676be3f362034f"
    sha256 cellar: :any,                 arm64_monterey: "979aa1e107478270322882433b872fe71003520fd35a60b210a1637b318eb5fe"
    sha256 cellar: :any,                 sonoma:         "f1c9a8859cbd77d8e35964e866a069e5627919082cf8347737976c601b8e7306"
    sha256 cellar: :any,                 ventura:        "36f26c4a2b6f599f0d56695c171d263323d77b055391ce822ab697790e19c416"
    sha256 cellar: :any,                 monterey:       "d38672a0166591d7d1272eb74e4db30d6cdd049da9e6fb8242c9898a0c70c70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06236460b04dc15148fd377a7cf0207daa1e02f8fef56327de118931fb3c093b"
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
