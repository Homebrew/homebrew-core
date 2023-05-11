class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.7",
      revision: "68d09f20dfde6bc617f1820850599b005a01c034"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "913496fd2a31afa3aad6f03e9ed25e15a94f42b87a9cb42fa8e7a4faf8dd7870"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b02db242bd620d0131c6b3e40f9e6739cdc090bb870ae16bae35d30a415c2fe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a2c68ac142b0f4cdd2a1648eba9e68f322a5ecc3b9fd7ab1af0c6bf85609e6"
    sha256 cellar: :any_skip_relocation, ventura:        "b50cb0f53a4536e1f19e62e6bf90631a3562ca3f1b3bc108e4d8b2943ae89a38"
    sha256 cellar: :any_skip_relocation, monterey:       "5992b69086cb51be84ecb6f6b66c20dfebb88a00cf11744c9199f9020a19eb63"
    sha256 cellar: :any_skip_relocation, big_sur:        "a720069cb8d59feff1ccaab23d25a21a85452aa9e51f5b9e72f15ccd28a4c3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a957cc7c82d24bc03cf628564de70b97209d8fa5ced2672a23be05db5dd84d0"
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
