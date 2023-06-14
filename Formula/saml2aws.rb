class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.9",
      revision: "dbf593a54386f123a5d50163d8ca90c806aef838"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52fd3c090f0d831303e8ba4b4fae03276f6fb4d60f21bf74de638d868ec1faae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4155b513e7183547f58f90f76f14baa592c4bf871dcaf6dc696d216a572891c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebd1e25725bcd43a1f7eb09b65f20b89a65219a088171a467b1a1604df67c252"
    sha256 cellar: :any_skip_relocation, ventura:        "ee8a411bdd9d4bc3c269aa530d50a8a51b0e2dc427590fc961c6642a22918da4"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1047e848ef6d11e8178176900a7f3e94fd7287809ec922a5a9bb90e91a2156"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ac45cb56581e7339026ea53794142aaa978296f36557a5079ad66a0a8195544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "871582ecaa99c666e3612a91d92576be265bd806cc6c8b4f31cb9419906ee3a6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/saml2aws"
    (zsh_completion/"_saml2aws").write <<~EOS
      #compdef saml2aws

      _saml2aws_bash_autocomplete() {
          local cur prev opts base
          COMPREPLY=()
          cur="${COMP_WORDS[COMP_CWORD]}"
          opts=$( ${COMP_WORDS[0]} --completion-bash ${COMP_WORDS[@]:1:$COMP_CWORD} )
          COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
          return 0
      }
      complete -F _saml2aws_bash_autocomplete saml2aws
    EOS
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
