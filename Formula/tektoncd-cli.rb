class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.20.0.tar.gz"
  sha256 "91ef920cc37fd58479304ec104d4233a358f123ea2919cd8e111cd28aec7ce82"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8dfa1bb855bf15e575f9ca543bb17bc028e832a28b98f4c46c26b3025fd06258"
    sha256 cellar: :any_skip_relocation, big_sur:       "aca5a966205a0060e8abea04025809772245c25dcdc64976f28ee77f6481b181"
    sha256 cellar: :any_skip_relocation, catalina:      "3e3fa67ce9fa22f4fbe89be521407cceb6267f8302954a1557a7a83f8b9e8f56"
    sha256 cellar: :any_skip_relocation, mojave:        "9b274ec482c44afaabfe9805532864e714b51f96e4cd36ae9a952352756861de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df9c21d7eeb768b18a43ccd818bc4fe561acc5a25b164ed951d226d9c7bb4032"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
