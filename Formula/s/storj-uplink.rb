class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.110.3.tar.gz"
  sha256 "d2b6b1a34783c3a85d1ef0aea7665c2427cbccaa3571afadb3e7af3e7ae36c23"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb8d08506c7b3366bea6b1d56a57aefb82cfdce1a270f632cb353fbc960833e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb8d08506c7b3366bea6b1d56a57aefb82cfdce1a270f632cb353fbc960833e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb8d08506c7b3366bea6b1d56a57aefb82cfdce1a270f632cb353fbc960833e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaac9a78dfdc5d7a3a95e4ab39445eb9badb6ec4ff8ec7fe3e689cb86a18b794"
    sha256 cellar: :any_skip_relocation, ventura:        "aaac9a78dfdc5d7a3a95e4ab39445eb9badb6ec4ff8ec7fe3e689cb86a18b794"
    sha256 cellar: :any_skip_relocation, monterey:       "aaac9a78dfdc5d7a3a95e4ab39445eb9badb6ec4ff8ec7fe3e689cb86a18b794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3179a6c407b4e81c891757af050f2cfcb1ff6719e45f80ee3027cf1449574c77"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
