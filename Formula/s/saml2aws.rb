class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws/archive/refs/tags/v2.36.18.tar.gz"
  sha256 "df31cff6e82558869133b9d6621cd5719719df02e3df645f4831c671ef23e63d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab406c3b45b10f547f455996aeb0a3815506f2545822b6f07c3c208ad1e46a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9f3e7ef9a4b3d81c03c084a5499c538a9d47c854da48f9ed1b9afbb2c0beac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e8522fae4ba1e6b0280d940522a07b1d94961dad6ea6d4bc56662913d0563a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c4f8bdde7df58404344b48f0f9f885c45a7e58c2720b11de4cfa85be9ad18b8"
    sha256 cellar: :any_skip_relocation, ventura:       "f57d15097663fd5666029d3ded213d26cc564c44f51f61c527e72c66e158ddf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb931c1558cf66a2ae61011156e18f672278ebbf918f2da446bb298ec7b28d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/saml2aws"

    generate_completions_from_executable(bin/"saml2aws", shell_parameter_format: "--completion-script-",
                                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/saml2aws --version 2>&1")
  end
end
