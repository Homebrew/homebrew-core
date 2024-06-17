class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws/archive/refs/tags/v2.36.16.tar.gz"
  sha256 "a2be057a638bef4fa3c9537adcc8683493c09e45a1ce250ee964e02628535543"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1393a352528c9a3ce8e435b99a527feba0b036a778a73b6d15b6c4e0cec42884"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cbd3f0a9731ac2cbb44e5d83e72daf5d1ff4f755f9310f64adb4a90a3efca46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5463b4d697e15fd74ac291da6437c5c41f2c760f8121783b9535b014c69380f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e80babf04e60b2b472ed18911e3fd7c2da5407fa4d9d376a8f32a0852788c54f"
    sha256 cellar: :any_skip_relocation, ventura:        "72089a9dce33d8ba13f0cc538386a9e6be46dc0e1caa30928264058711edcc5a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a6e8a069d3ed8dba6f29d459a9ef1c9b9e3bc1e51fd00437c79920317105162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c396bfa44372963f350fd01b570160bf353f1bf32a2c88642a43705ff07fe322"
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
