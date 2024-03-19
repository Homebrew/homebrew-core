class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.14",
      revision: "f8df0dfaf16d2e3938a1cb96ecd68b93a6fc01d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "279804432ba3b62b1929a11a1296a2ba2a5dd0f6eec3f9b25849e17c69e5747e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "217cb205692c52beb5b595c80fa7ba6a2bbda4e13592458e9495aa831dc67023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeab8c87fc95df5cda133e6ceab8efe368c766bd959b906b7adb142c1e883826"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad75b5ccc7d2148d2f6f9293e33826ad8b86ac2c7e37a3e896a37b53a612cb91"
    sha256 cellar: :any_skip_relocation, ventura:        "c95a6a7d454b32cdb9f909a73ab249c03cf710a86b71d25553483524a2c843e2"
    sha256 cellar: :any_skip_relocation, monterey:       "4e66753ab2767a72ad4fe581b23b0cc67033db55406e1b39b3cc75ed59d7e3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ae063cae4b22e0c1607495f43c55ec7ec14f02dbc1753d187ce1d91fa5f5fa"
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
