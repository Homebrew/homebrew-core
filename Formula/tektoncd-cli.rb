class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.17.0.tar.gz"
  sha256 "94f400bbf1102ef2e597f33e516752cdde1ae98925fc06eb735669f6b38f5b7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d57f90252780dee21605ded4c56ed0da02841e7e1e7e7b68cd42baf152502f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b796cdfc635b3b3b87cdcf3e96cc619a3d42fc9765e2da352f07d1db44e1d1a"
    sha256 cellar: :any_skip_relocation, catalina:      "db667dae01d659dff9cb3323b3736f0af234f8e930c2b3f54652b13bfc1247b7"
    sha256 cellar: :any_skip_relocation, mojave:        "e8576ecadc6ccf12345c04c17a22438e965ef2b5492422e5b260e40f512e9130"
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
