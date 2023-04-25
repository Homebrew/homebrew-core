class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.30.1.tar.gz"
  sha256 "f927a7250ec3584940c701845be793f8dbc48ec0c421cf1b96b177bb2ea45531"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19608b8c293e672d2c8cff7b682417df2ea1bb3815acd276d8b1eba47b0cbc4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71fe8f60a63ad2970a011fca609480fad5ce6c6548c36033741cbc3ee8240885"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "817e6f4bced3a65b0dc0dd3a01ae123ff72a5a844bc0c133bcf416e6b9ed9f3c"
    sha256 cellar: :any_skip_relocation, ventura:        "36e441f61ed5432f050a5aa7989b692a28c2873ae642ee4a40af197fdd730a39"
    sha256 cellar: :any_skip_relocation, monterey:       "29071dbb2e0f7c9b5323404d4e245523e048b126ced7ace91015f4c8e8c31c5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a13408a678d87aeb08368f1a1e46b5b72a27ec1ce23d42d46562ee4a8ccc55ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eec6656644aac19adc9c82c62623960046c9a8d586b57699bb7c1381b3045dba"
  end

  depends_on "go" => :build

  def install
    system "make", "bin/tkn"
    bin.install "bin/tkn" => "tkn"

    generate_completions_from_executable(bin/"tkn", "completion", base_name: "tkn")
  end

  test do
    cmd = "#{bin}/tkn pipelinerun describe homebrew-formula"
    io = IO.popen(cmd, err: [:child, :out])
    assert_match "Error: Couldn't get kubeConfiguration namespace", io.read
  end
end
