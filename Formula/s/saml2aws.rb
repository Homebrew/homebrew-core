class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.14",
      revision: "f8df0dfaf16d2e3938a1cb96ecd68b93a6fc01d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05ed5d4cd39f658044ba3375651d1a0f7cf9cc23cee905a6e5ff4f8eda31319e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5befbedf07b6c6e34b5974d6a46127707aadf7005bc572bb01b1ccbabeaea283"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbafeb9e0b96c68f51c3df524a768cfc8f04d29279bd67907cbe413854b77de6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f914962a0f75312c8bbb2274bf53193e83c4ef3e9772f72310db43ffb67c1a8"
    sha256 cellar: :any_skip_relocation, ventura:        "7fc99aafba6d183e14ac886f956eb2842c1ffc22e6d5e44b8f320aa26335c4cd"
    sha256 cellar: :any_skip_relocation, monterey:       "ee3e6588f8b4a3da59f3040cace319408056f25d2cc8964c67718fd541dcb42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9fcfb90260606579c4bd9c10aaefdb22116fd693f15f05d30812818948aafa7"
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
  end
end
