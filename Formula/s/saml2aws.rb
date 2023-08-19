class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.10",
      revision: "e6ebdaedda451e46cd0b9b7148503c2d010d2e60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05830f4b8d0daa3871e440b034ec14acedeface007a62b17420f4297d7dfed7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "693db51e4aa2a35bd7b88f36b76d00f29b1abe50d1cb1d53b987b079d2acface"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eedb5ff8b30509068b739d1210a362e216cc163aa2b3dfa7f797cb2a6e1a83a"
    sha256 cellar: :any_skip_relocation, ventura:        "e6d0e6f38c036c76257bf3abaf3b28ae88e4ea5ffd1a29199deae9fe9968dcde"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd7009a56b66080730962efc7721c94bb5808f3a4be5d7c678ef4a39613a23f"
    sha256 cellar: :any_skip_relocation, big_sur:        "42f8d5ce2ddfb387f8b1e031a1762f955713924e1b04d9c7e06e3b2f794a09dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb8f48eb7a95d06c64f1b928587606c783d7781b901d8e4d853f214ebf7facdf"
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
