class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.17.2.tar.gz"
  sha256 "0f6103026e4ac0f76ab1af5f5fef2dafbe3dc673861557479310186aa1d341cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdac9d99a78ed23ffbb13397027493e0296964b1747e2e08c8d9673e8113c6cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "108cae7a645a8e18a08a2152ecfe853b0df1a1f635b13209f190c45484da198d"
    sha256 cellar: :any_skip_relocation, catalina:      "628597d1784087456f98f3aaa5dc8bdeb763b24d7579e3cd58154904f5fadcd0"
    sha256 cellar: :any_skip_relocation, mojave:        "7e6589646e8a24d63e07a0218dc83ed0fff2541e49fadf4d40e47a01aaa453ad"
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
