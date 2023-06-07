class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.8",
      revision: "be18355f2fecf98ccd985e3d543f9ca30a948ab2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ac48342ae291038ad6cd6d64ae593a260dc843298bf1be26e18e6a87992ec12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d72d4bd9e708b1bdd9faa2d5c666486d3e7c4d0b23b53cd922c6645ee7e6530"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a9ebb1828c98f56e0df7aedeb906233f7372f696a26b664930cefaec1e4690"
    sha256 cellar: :any_skip_relocation, ventura:        "9c475a4c4a8f336e917671dc9b4545da362418d1bfd1209f4abdedebc10bc295"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c19821975664ddb2fba532789a19c56bd2bf2be7ca1be1c28da7fd80bad852"
    sha256 cellar: :any_skip_relocation, big_sur:        "86a60a43d4fc2debdcee5244e4bd0d8caa0851e2849cee49207a22646f326c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aaf97c85ff010c5416d2ba0612ccfc4d21b5ddb703b3788e627de9db91b674b"
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
