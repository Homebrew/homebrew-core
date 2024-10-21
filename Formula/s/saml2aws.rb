class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws/archive/refs/tags/v2.36.18.tar.gz"
  sha256 "df31cff6e82558869133b9d6621cd5719719df02e3df645f4831c671ef23e63d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76b5e3fed843e898d9bee13f7775893b68097b6bdf2910e1e6ea4c5053a8729c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5950ee47a6cde9792bb1e8323165dc7315fe42202db86e7c164b4e8d36cd984a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88624f47b35bca83e11ffa00728d9cb9f284f0810403e6ac9ed222d15328b2db"
    sha256 cellar: :any_skip_relocation, sonoma:        "db41aeaf178c51adaf9f92bf1a5e8b442d1c963d411163bb3bd16191a0ea1356"
    sha256 cellar: :any_skip_relocation, ventura:       "fee75a7348f7ef8267250ecfd5ce3fc526893aee4ff52af0bbed1022281ce7f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e7acd082bd09209a3a4b58a72a32564da050ab19c1b669b21e07d0f8a77ba9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/saml2aws"
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

    assert_match version.to_s, shell_output("#{bin}/saml2aws --version 2>&1")
  end
end
