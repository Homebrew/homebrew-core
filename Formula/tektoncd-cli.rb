class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.21.0.tar.gz"
  sha256 "c6fed13ddd0cbb410230cf85749458a42b9cb8d56ad6ec48b44e70e26cce9062"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "576a8fbcd92ce3aeabaa04da22bff3c86d06fc657c9718c0f335fd149738c41a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0881c0e76a55091d22e195899959a54b63b6976446ec70e5286276ff55c5ad53"
    sha256 cellar: :any_skip_relocation, monterey:       "20b643056326a5be719bc01d0b9e2aaf383e7047fb0c51dd8f50d8aec00bde9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c2b9eaaaa3ab5753a5bfa8a4c10debda5527f5770579c0fa4a68119f1e2334d"
    sha256 cellar: :any_skip_relocation, catalina:       "4fd2242d4b05b626ab1792ef7c7edd2fbf68eb6879f80384ebeb56969266eb4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3896c56db634577accc28d83a23e7bd8d0ade5d0bc7f4dc98c49fd9b8a872ce9"
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
