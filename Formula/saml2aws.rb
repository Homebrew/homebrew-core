class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.4",
      revision: "8e2688a6fbbf6331eb58246a62dc42060b6229f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42fe296b015825891aef39155be3a0b18e1611c8ece2b3385f2ab003287a0a0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13f7a65ace69fd57016f107e890bd359183eba0089656732efa7d9001d4f69c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9b5473908d087f6376e38663e5aad0cf112d5e991d5c60e6f641400f919bf03"
    sha256 cellar: :any_skip_relocation, ventura:        "52e483235d8b151e4368d9692b4993091b14c61772b24baded41f824e5432f3c"
    sha256 cellar: :any_skip_relocation, monterey:       "434d38cb818331b2a59828b9bd63b4ae7aa447532d6ed1569d89bacedb7ede26"
    sha256 cellar: :any_skip_relocation, big_sur:        "354acc267a6a8048209a92c06d7e70cf9370cbc43953c0bb6238cb7f90e7e35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3bfe745704bf3a4bb4c1368d5bb138cda10e8dfa1ac42607c2460094860dc8d"
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
