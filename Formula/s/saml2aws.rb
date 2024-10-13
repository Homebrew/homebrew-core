class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws/archive/refs/tags/v2.36.17.tar.gz"
  sha256 "b0c4cb7f24f7aa1b49efa62c3eb6d176e1aec195ff76ff7138dde90ff089f188"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "80940b2e973766bfbfd5ccfc5ae8c3812269e2d3d9559cd74e9e1097f7172d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87fe1f852e97a27df7094e2aeef86346cb0d05b2365c669f7d173bd8759a5b7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b0c1ce1057db657731aec64e070fd9270809ba482885a0ea8913da4c68f47f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df320aecc313f3eccfcd1802c40585a30dd8ce4710e6eab446ba941280f14c96"
    sha256 cellar: :any_skip_relocation, sonoma:         "a44c09975b626ea05e1a56809404bc3ac90bf33bf7bba90b93572667eaa0ab0f"
    sha256 cellar: :any_skip_relocation, ventura:        "17cbb83765d3aed1320c9072c0ee62bbdc02acd3292189b806f7e1af06674bb9"
    sha256 cellar: :any_skip_relocation, monterey:       "1f258e7baa6289c4fda8e7db48ec5a3614e79efe0ffd4d1d7c1616a53844ce85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e867ded478efb9fa4a12dcc89d62af1e5c4b530d0b14a42efd1d425d6ef2dd1"
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
