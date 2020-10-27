class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.13.1.tar.gz"
  sha256 "2a459c8ff9924558aa3f845a31e88826a799351df8f8efa8a3d8a6e444db9b80"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ab5eca9b39fcd63b2288c1f699d0530e9d77884372b4c13405a170ca4180fae" => :catalina
    sha256 "3158e4491b1c57e3e380f91023a29d5a4a82141a687df1a5323fbe2c0b6a5396" => :mojave
    sha256 "d63340b7e60ba479b925a4f086638c96d8a9a5e62b9afa12a0ee4c13f7fe7ed0" => :high_sierra
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
