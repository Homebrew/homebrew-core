class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.12.1.tar.gz"
  sha256 "f931aa5792a08ac628cbbcfa5c295ffdbc4989186713377583e5e595eb22a80f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e5865734d48c4b481b6d3267778dff39dd41b581b3bf6b0e9c2633c51ac1587" => :catalina
    sha256 "9309320f9399be036fe136af779a1e18ffd73b7afda23d16d1bb10d74e319aaf" => :mojave
    sha256 "7347d6ea7cc56ab0782b362bc10a9091e4eb01f26b3745d649d8d44da4fed8c5" => :high_sierra
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
