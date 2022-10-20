class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.36.1",
  revision: "d9d8139de63f28ecff2811bb815d5fe55c019529"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c07b5bc5644d4acdd8acf6da32458d3ebcf18bbeded3794488fdc68b3e78b278"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66ee4cf4891a72fb789673e1534e2427bdf587df83d2e0c05272f1894943ef83"
    sha256 cellar: :any_skip_relocation, monterey:       "ed089cc11626dae4c2cef41100ce747a97d2d6996fc2a24564bb907aacb40a1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "83d446127895f5dac4a8a88d4a59fd9265e7598410ca4f63f4e84c707cf246c1"
    sha256 cellar: :any_skip_relocation, catalina:       "13ea245e58ad8bacf86a607bc9138d56efc91f4c9bbe2c8a14a0950c4cedd103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f5df5cd3c19a3bdf1736b17da2b266d8143b112b52acfcc49282f0581c40d0e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}", "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
