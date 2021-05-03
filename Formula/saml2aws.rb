class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.30.0",
  revision: "49701e7d9563da09ad93f13db0cb5bd90a57bbc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ba2e6070cb56a28cbc401369c7aac0e5999979a2d9cdb2ad4d90ab9d8dc8237"
    sha256 cellar: :any_skip_relocation, big_sur:       "d70ed5c64b671a613d366132ad918358f5ed57764d91c3dc259b08be55d82f8d"
    sha256 cellar: :any_skip_relocation, catalina:      "f1de88a0a3812f32dab70610870f6f69801f820160e29339dd0ebd88ffcf19e3"
    sha256 cellar: :any_skip_relocation, mojave:        "8d2167abb61d6fb6f1822725bb55479f7dd081be9c4e20fbb582669bb31d5c31"
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
