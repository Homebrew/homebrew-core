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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b6010117f41dbbae009bc6df3415c0cc3efaac49e186e964f37239481760f1f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "23ff995156df7e4f8dcfb93021523bdfc9da375ae49f9c5cd4b0ce492963e1cc"
    sha256 cellar: :any_skip_relocation, catalina:      "c27830c57e654803fb7a35dad330afc8085d72ac85249aa7fe10df8a94e3def2"
    sha256 cellar: :any_skip_relocation, mojave:        "eedba2b8a0a5b9e3112538db8f7cf7857cc47f6874368dc7eb744478a3a8ddd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b729cdc063f58d228a17a19b89e4bff34d581b6b27454831b6e3764c17c228ae"
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
