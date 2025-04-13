class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.1.6.tar.gz"
  sha256 "5995b32c065715e8da2fd83ad99c07de4938ff55d46c6665bdc71b74814236a8"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7787dbbe3ee2f19c82c423b36a43d9871134701db11c2c49d89ace89517c7be3"
    sha256 cellar: :any,                 arm64_sonoma:  "bdcab632ce9203b0a16ead448b461777f31dab4c1b7a4ce9a106408f71aef9f1"
    sha256 cellar: :any,                 arm64_ventura: "5547ffb215b63be6fcaa65226681e0b5f97102520806a7e0707a26d951f6187d"
    sha256 cellar: :any,                 sonoma:        "70125dacd4720370f91e417a92fe9395b960d3931e8c7f105d1bc7888413cc3c"
    sha256 cellar: :any,                 ventura:       "a400d238dc421733cbec9f3105c81c845386d840df433235ead7b99298c24277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a692bc15c933bd05d510729df7951e980204d83278b149a44a4ea11a495da4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ad080bb9772d351c5afb1ad2eb145b1385db081277fb31bc7782f8f0f67742e"
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
