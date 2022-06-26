class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.35.0",
  revision: "df3f6cf6757279e92c1dfe7e0155f0a60ec68d6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0d07e8e562ed01867d7aa6b45ce8e649ed57e8f52901b07a484522dd0907a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e125377435cd04be0bb899dfac6eba0dabf81f9db56616d470edef13b8aee827"
    sha256 cellar: :any_skip_relocation, monterey:       "64f7ee72cb928b92eb60e40f9b69edc8a512952d78bd2032aa2ca836ca068338"
    sha256 cellar: :any_skip_relocation, big_sur:        "3735e63468969541e96471826840199e3d8ba1cca111f60b46f2af6740264a40"
    sha256 cellar: :any_skip_relocation, catalina:       "b4447086e1ee2004ae04ebec7617803607bc432233cabc4c969d674acc232a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "190d240745c077bf22c83c8b53019f85f02f6387995d1f5b7db98397303a1c59"
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
