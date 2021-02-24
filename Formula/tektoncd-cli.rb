class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.16.0.tar.gz"
  sha256 "7d45160ceeedc9133f05ed618d72996ab3cbfc8d7bfd62f689de355a0073d599"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d30111de197d848b36e37f5a3852681168984f689d60d8b6be89ce8e5abc13be"
    sha256 cellar: :any_skip_relocation, big_sur:       "e627288746eec625734e7eec88a577534bfae1f5a959bd3dc36e737de2b5e2fc"
    sha256 cellar: :any_skip_relocation, catalina:      "cf58ce643dc8741e3a9f6ffd71e4d2499104aba08cb7e4e57945e8362be363b1"
    sha256 cellar: :any_skip_relocation, mojave:        "8c00be69f665e1793960150319ee31fe0067ca9f4c9b5b71bd004cbddb571bf9"
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
