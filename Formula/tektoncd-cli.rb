class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.12.0.tar.gz"
  sha256 "ecc1e5da3c5347333ad519a4b10a82d53e3bdd416a05c49bf119fb8a69b39ef4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "74a9712359456c14b1cc738a12a15272b0ceee75810c7a6cf6318b9246c04e4f" => :catalina
    sha256 "1f82ba118242a987d09c5bf0c9a0f21bbdb9de07d72ccbb33ca9d3cf5ab6e464" => :mojave
    sha256 "0af75cfd0ce62d3de8d667b8e4e45967397b388ade7aff13a6d3053209ff2be0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"

    bin.install "bin/tkn" => "tkn"
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
    prefix.install_metafiles
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
