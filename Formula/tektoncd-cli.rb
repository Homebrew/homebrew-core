class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.23.1.tar.gz"
  sha256 "49ea8c907c10514e219b3536fad481c537c09b8fa264eb0c0f3c4ece61bcabc5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cc4d5c7938201359dc2e7501aa43d132911cb6864dd2a90241175fb3e659d12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36609488807222e95fb00bd8247f98bb807b1df260d845890108934c7e0383a2"
    sha256 cellar: :any_skip_relocation, monterey:       "b2f62bf93ddda53da90fd996dbe09304b9b97121bb1819ef17cb242f2b020050"
    sha256 cellar: :any_skip_relocation, big_sur:        "a54719f01daf78164dbfae920b78faa52745136e756d46d26d0f3d62641220aa"
    sha256 cellar: :any_skip_relocation, catalina:       "1c61e6d0f08c45d25bdde8ef3ea2e774b6a5740be28d599424e67e42145c7c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fd8077f4dfa67d56468383626b555406707a1bf756f97dcbb23ef16eea49b86"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    output = Utils.safe_popen_read(bin/"tkn", "completion", "bash")
    (bash_completion/"tkn").write output
    output = Utils.safe_popen_read(bin/"tkn", "completion", "zsh")
    (zsh_completion/"_tkn").write output
    output = Utils.safe_popen_read(bin/"tkn", "completion", "fish")
    (fish_completion/"tkn.fish").write output
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
