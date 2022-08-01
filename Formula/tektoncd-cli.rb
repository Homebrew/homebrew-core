class TektoncdCli < Formula
  desc "CLI for interacting with TektonCD"
  homepage "https://github.com/tektoncd/cli"
  url "https://github.com/tektoncd/cli/archive/v0.25.0.tar.gz"
  sha256 "24bbda9bc5839f951f94a97bbc572e7fb8b4defed0a69b2b588c7cbced2dbccc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d27f74fdc44b9582a3f3ce69c388959cd5772e62be6c14260fe33c8a0cdeb2bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f96c242e69348a28808bf917c78f96bb3a3f663f7fb7c16128cfeecee5802c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "1e51be9927b17988bea12821a19b6c4f243bc077db96cbcfab5a72d7d1ad6fa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "efd66d5f117b7a8b5a047d7cb4fa8a1299d1c5e2d7c22a883d6fd025b1db7e35"
    sha256 cellar: :any_skip_relocation, catalina:       "a9a5722fbc9d726abf0788eeb39690efacd26668a7839b106b0ab979d30d6946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d98fea8cd381e4dbc696e13797ce5f35a6afe2fbde700f052b39a5b71a4bd8e2"
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
