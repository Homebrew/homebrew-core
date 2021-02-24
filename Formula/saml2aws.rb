class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.28.2",
  revision: "2147b333a6f9b8769adeb744e0bee188d913a524"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a15ac811a4276bca7ffd9e7c90f8e5b260c78e82d6001f8e1b61c86010a6051"
    sha256 cellar: :any_skip_relocation, big_sur:       "02c8c34a19c9b252b0ccf3daad37e2cffa9881ac987a3e74b345e3662ce17dc4"
    sha256 cellar: :any_skip_relocation, catalina:      "cf5705ec3df26799def37c758a884ea4dd8952bae57f758b1d290e6e506d98c4"
    sha256 cellar: :any_skip_relocation, mojave:        "f049679b8169b048ecb4d16dda5b818a5f8d4ea2ee62b771ee7bb8b1348e1889"
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
