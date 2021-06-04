class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.30.0",
  revision: "49701e7d9563da09ad93f13db0cb5bd90a57bbc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08c1cc79cc86bea367ac9ca4ba0926dca81eee63c9cd05bb3d0621cda2a6ec34"
    sha256 cellar: :any_skip_relocation, big_sur:       "9142f8affd33fed9f28bbf03875372c1dddf21372e9f94257c4b08d2a4d69b6b"
    sha256 cellar: :any_skip_relocation, catalina:      "90a257e0b310897d51e2ab594ff08332cbd74e7e628a5f3253b5a07f0303cea4"
    sha256 cellar: :any_skip_relocation, mojave:        "78886a4e4d3c5280bd0f02f85130045f9bfa8ce0f86aabd3573966c887d57924"
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
