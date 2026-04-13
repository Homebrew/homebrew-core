class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.2.2.tar.gz"
  sha256 "a1b4e4f1a52920089aaade85a7b900c8f2683937f49025c821b9c9f2b25db9a1"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abf87030b9052906d11558e3791c9bac39d02345b08b09750b087e426f0a19a4"
    sha256 cellar: :any,                 arm64_sequoia: "a246bbfa7ce941d352be551ba84e80985460c0fb2f270111217401ba7442ad75"
    sha256 cellar: :any,                 arm64_sonoma:  "03658c9954641a8fdd3a06a18119e8ee6b3155abcd747132dd2f1449921b6095"
    sha256 cellar: :any,                 sonoma:        "136412efca3761319012e8993c2af3fa7db0108973ae0bc553a7535dc6412c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bb7a15753a2b8ef1a098ba0db3dd723ff8610d1b07492085ef57eb65635fa47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22a261ae4609ce6659cc5213e7d01fb5ca4322d6f8207374e4e29033b55451f"
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
