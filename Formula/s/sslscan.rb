class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.1.5.tar.gz"
  sha256 "b36616b1d59f3276af6ff9495ab8178ec6812393582fb3c094c56cc873efe956"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1797e78a14d60fbe5858b5a8da65295b83bc44f4bc90b3d79c3bb02491ff3f47"
    sha256 cellar: :any,                 arm64_sonoma:  "3a1564d527b7be9ca7d2a19ed6fade0e8ec32d534206c89a2fcd5b483169b20f"
    sha256 cellar: :any,                 arm64_ventura: "d5b864e56730b2934f0d72c701c575b160ed5551ccba349ce2e63673fb36e13a"
    sha256 cellar: :any,                 sonoma:        "74c4decb73061fadbecfa0e3c118411fd986dde4c10b218aee1c161d9a42d9f9"
    sha256 cellar: :any,                 ventura:       "2a381ac121ccd746a9d1f5df5f1716ab2c86ce67f10475a2f4b145d088870f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79b83ad91bc7a8a093b0a1df8aa09e86f975c213bfaa42a58aa0886c87e2f36"
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
