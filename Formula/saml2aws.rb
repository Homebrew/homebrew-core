class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.28.3",
  revision: "3251e9c0edf7a35509d172ed6c8fa16cc50175bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33fe29a31364a6c8094f96551aa304346c91e34933c1b1b9b8c9326dd739e8e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "3aea6fbcde8d895898682aed9907a999ce752b51a54d12a6fae45335c20b1462"
    sha256 cellar: :any_skip_relocation, catalina:      "f06525545549daf92a22f46ebffab8d3dc0ae074577d80476967d6f45674fd71"
    sha256 cellar: :any_skip_relocation, mojave:        "7cd5d66ea3404a6ed0d5ee789f1b27400beb255945115bce619538430eac4111"
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
