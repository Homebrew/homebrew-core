class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.15.0.tar.gz"
  sha256 "fceab0b1549d941915523b2cbf4dd08d621b06aaf034f8a5e087775283341a18"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "70636db8c11992cfbe070adb7d1f74aa47096a00628724c35058703d3845adb5" => :big_sur
    sha256 "8d8c8237e6b1193eb3f49f9914cf1e934438773c7609ad81376aa9aad56d1629" => :arm64_big_sur
    sha256 "469b051b513331e5cee9b380c1586613ecfcbfc7e384419e4b27b2c48a35e2d3" => :catalina
    sha256 "22ac2d25c1e8a1c41146137a3637e248e6e0a69a7af53995945db442f30ed805" => :mojave
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
