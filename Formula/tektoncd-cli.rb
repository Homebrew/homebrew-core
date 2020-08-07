class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.11.0.tar.gz"
  sha256 "cce12b9674e9e4891b870be24fd46d0877fb15ce23a790c90d68a5d7817e151b"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6d86bb4f643c1fd7d7391a1d96b77bad7c1d87a2ce3e29c86ae09449f2a43f1d" => :catalina
    sha256 "1653d2cb638af1112ddfd74f16f05f00cbfb6271c783a9a6b83c4e620e9252c3" => :mojave
    sha256 "a0532c74eaaf19639af4ba9fb7da499b5cf59b96436a15ed1b6ae869e17cac95" => :high_sierra
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
