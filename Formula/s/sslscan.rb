class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.2.0.tar.gz"
  sha256 "17c6fe4a7822e1949bc8975feea59fcf042c4a46d62d9f5acffe59afc466cc1c"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c68b958da874522adc15b570cb2c86c48361cf1412aacb9284dcfae698514ef"
    sha256 cellar: :any,                 arm64_sonoma:  "d82171a037a8b9cf84384979a08a06165e3c2955991095b57e7e53a904883467"
    sha256 cellar: :any,                 arm64_ventura: "933d1d3963d0371010c608bb04e2da357b894f1761292d0f99b6433310f081b9"
    sha256 cellar: :any,                 sonoma:        "fe6af6b83a3a9d59f3b0e2bf0d8048af1f17604bfe01a712618d0b0dac07cf89"
    sha256 cellar: :any,                 ventura:       "27fabd4a39bc12b99ffdc9a29fae4ceb318c65f7219c9a503e090534bb49a92e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f28ac870735144a4ed0462f58b6cd9dd6701390493fb84500309448d87f47fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f11cc61588af0da636c52e62a7e620d179e9e4f6779bc2f8da38fa1d0bec223"
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
