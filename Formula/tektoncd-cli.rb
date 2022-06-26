class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.24.0.tar.gz"
  sha256 "6382bd5be03a6c1ae51f09b9450934b71f84e96b6b14be92a3407b70ceb18fa4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2414d5b90eb4ffac778f9c4818367955541ffa26d27ce8de66ea9c25c176eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1519a8ff80358f52f589f5e6d7fdea655081f81849ae46d329abd5f7c127b49"
    sha256 cellar: :any_skip_relocation, monterey:       "c3d5ce70a2b32d0f36b4270d694ba4e85c39da6f2cfaf281526ddeff85a8e687"
    sha256 cellar: :any_skip_relocation, big_sur:        "20025c65a7990b2fae828919daf811ab1b39c56ecff3b9ba4edd29dd1a0fff82"
    sha256 cellar: :any_skip_relocation, catalina:       "7c9d99fa7894f00f739a331ed6b7ab8a5d697ef5e54a3e22dbf1d588cb60552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a0b5ad8f82cacbb02b339c49362111534e4b9e01e851e782e84bf0b3c7642ec"
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
