class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws/archive/refs/tags/v2.36.19.tar.gz"
  sha256 "208ec9e1f2e8c7e1770990825bc5e56c65cd86e8362e1a3e6fa1ef5ecc7bbc91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69e6077ecc29098c8898cb893541b71f13623162e33c8d2f2c8fdcba2b5d67f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a654e7f6931b60cb7a97c06b259a18b85d726500c2628cd032224084f6e4f085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1891facfc93e5503e4d43f944a8b997fae5a36096c7f3830f7d2d497e0f799d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23483664f18cf600ecb5005cf41156f729cbb835303a08bdbb213b2af804cd64"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aa3ed09c1047c5c9815cd2a3c5efac7de53695e20a4bad7e7350f6a87483683"
    sha256 cellar: :any_skip_relocation, ventura:       "442e6638949edd3ef4ab43cc6e75915145b33f1313e285dcec56a22ba58d3d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d094d781c37e372b4281139da3bf06920af2c78a483852e69ea9c325bcd8635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29e62a8821f75bfab2b35ebdc176976725aac06f4f3e57813d6e8e49c8e2890b"
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
