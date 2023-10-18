class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.11",
      revision: "a478a323e70a24d350c8204003568b5b161e9638"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27722a49ced042c0cf10db8905cc6572d708b8915977695fdd3e4601efe35e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf61d5cf65b687b6fe9dadffa73fb5dab7176e9f8d9961c1493a02a831bf6514"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81d6d0f5016ee73b47a6645a5cfc41133de04467ea84afcf46f705390df02a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeec7cb7b1c28a7f954318e2ff8eac1a2b2fb265033287a476d6c7c27dfea2d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8e6108fbcb58d0ff7ba17026ffbd827a7b0cac7b4167e786eeab6690241936f"
    sha256 cellar: :any_skip_relocation, ventura:        "53c656e9e555457b42bdb33dccf2dccafaf2f0ae9d26f0b4a7110b0b9e95c34f"
    sha256 cellar: :any_skip_relocation, monterey:       "4212d6e5d2ca727aa07a759046b48e9260e3063afab35e8d95bd06c22d63d599"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff30ff5599a51892855d505d17a7d36a7547520f4863eb55c824e4ff94af8783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c60b724cda755e441419e7a533398c9b9f50497fa8531028635e731a59676729"
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
