class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.18.0.tar.gz"
  sha256 "829a1be984eb05cab36152e124daae8fcb4706c25f6c21875f6ae319027fe809"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9fe4767970f512b80c5b2afab0a5eaeca008a80328f1a98a96419d764c494363"
    sha256 cellar: :any_skip_relocation, big_sur:       "4bc78cf2d023b4319e5ac4c7cd2635343ae9953cd205aa01502d16973fb53e4d"
    sha256 cellar: :any_skip_relocation, catalina:      "92875ed3fac42f9a9d191643ca9b14e6766a07cd6b0a187e4520e3f51915ce9b"
    sha256 cellar: :any_skip_relocation, mojave:        "a624d753ec18c4bdc16349380b139f645b616590e6aef2d83eb45d5f8d57d750"
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
