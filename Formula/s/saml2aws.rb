class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.15",
      revision: "8988caca5e3f597028ddaaccdb8ff71a92fe9bc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24ede64b83fa4823a974123478a8df54c064bd8e43ba4a31107d754aefe632dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0e3a1b04a820a68584674c05049aef756f4ad42ea7fffd1d20938f62bc3fe8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e161d3bdf2b4d405ede6947d14c8fd7578815ec131509f524345b1afd62eee"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dc1a3e9b5bf3363df3e03ba8b116c81c1c46cf4210e35b3724bdae92b641a62"
    sha256 cellar: :any_skip_relocation, ventura:        "0372ae26e5d7571a3866a689eaa211b3a1ce68c3333dcb8c199b44dc74391b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "9bbc901956babe5f2c0838ad1f38eb3769dc804693a5ecc1d877321492b87e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36eee967c5028cf5776558abcd17cdd9f33df1e1436cdabf5f96a3430939538b"
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
