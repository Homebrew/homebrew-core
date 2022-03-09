class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.23.0.tar.gz"
  sha256 "96041e615d9a95519cf1e226a88a3da055162dce0704351e6cd8117144a6d047"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61583d36799bdc288c999f420be9cf344399cc4563778b99b93b5fc4652350a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86da0c9047c2463ce21b619e96ec4071b257f60daff108085efbf451bbd85069"
    sha256 cellar: :any_skip_relocation, monterey:       "2f4b8897725c6144db96b15408600cecd475c57dd401b7aaae6dea55c566e131"
    sha256 cellar: :any_skip_relocation, big_sur:        "050b5214be5bf3bbf68a58db54557a64f699d94b2a06eee5520d75aca2f0abda"
    sha256 cellar: :any_skip_relocation, catalina:       "ca2398b83fe6a8bebb65ed6f1d62a1e4e0d06b21cb97dcaca042def904039cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec9cce77182fe8a54476b0764b0c0e887be371fcb0d239c98cff8a0960bf3e6"
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
