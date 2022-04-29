class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.35.0",
  revision: "df3f6cf6757279e92c1dfe7e0155f0a60ec68d6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2cb9501e89aa5241b8b0b2e99d673144b9558202d2135d88983b1d2679e5470"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be89ba0d54385b269298a8f11a18f683735f43435e400fe55a281a01c953868b"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d3517d29440fd9a1a61e9ad000673bf9acd06927164516d6191d1c1679264d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a297f8c8f201a9cc72163c7131c0a8913b0eb39d7e4a5cb28b9048e620760f7f"
    sha256 cellar: :any_skip_relocation, catalina:       "abd5b71f72603f9691fd2cf25f0ab55e95aea9434f2df46ae7f8ba920963b573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74ad909d1d2da0a153fcd3b295bda917d84e8df7dd03f3c91bfe8a1fccea1ef"
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
