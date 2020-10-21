class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.13.1.tar.gz"
  sha256 "2a459c8ff9924558aa3f845a31e88826a799351df8f8efa8a3d8a6e444db9b80"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "637921c8567547dba011c77408898008b946863b953bd0b9c73870ce5cce4bc7" => :catalina
    sha256 "ddcccbdcc0fb169f9acd56c56623253bc91570febad128db6d3948e7989257d6" => :mojave
    sha256 "0b98042fc253cb58f5ae3a89c1c22a768fcd68364ec0826de831e7299f4b82a4" => :high_sierra
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
