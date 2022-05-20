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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "854facd575ffe796bed332b0a5718761ab93070a7e31569f3902383ee367ee02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a6521c797be2cb7afab88984e3487517f5fcd86702463c174eca40d8dcefc3e"
    sha256 cellar: :any_skip_relocation, monterey:       "cf30f50ed353283c3da876f1616f2633d471992438125f3be766087b79140109"
    sha256 cellar: :any_skip_relocation, big_sur:        "6301e48ae1b13c59e2edf6d3645484233f0417c395d58ba8ba8f69627f8a57b0"
    sha256 cellar: :any_skip_relocation, catalina:       "917f87b9949d7e48dfe8376b3fef5a841036e0737add3f41582ccb88433db78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4437c493f8e8bd5a9aa538d97b68d86d389cfce0c684bebe9f3c346c4680fd86"
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
