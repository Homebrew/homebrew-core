class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.28.4",
  revision: "cd493549dfd492e4bb16cd5f8d3b0dfae410dc9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c01d3756c2dd64e279cf219b17121ef951c7b1f22bd15633dd52b3c07116cbfd"
    sha256 cellar: :any_skip_relocation, big_sur:       "52c815a82d7005f83d06acb56620509433c94fbd14aeaf8e6a6af1c81f0048e9"
    sha256 cellar: :any_skip_relocation, catalina:      "0e1a97c228f9afec60f0f94c313c97111bc8afd8cd092ce3f95a902395fa846f"
    sha256 cellar: :any_skip_relocation, mojave:        "9d5b919d89387c6071dc9f434900013ae719ddbc376ad308978b2412d92f8047"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}", "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: failed to validate account: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
