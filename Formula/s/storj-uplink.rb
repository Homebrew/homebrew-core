class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.102.4.tar.gz"
  sha256 "c0bdd33e5ab268be1d79251e5cd72e5611be2130dfb89a87ed4aa23c79902446"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c9ad105e5d3a1097cc09cdb9e005e50f7d4723627d05357a4b2f62e38bb6274"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "578309f8bae1751b19463a6a3ce06c598d622a9d7b20e98c3161caf08d90870c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b7e580cda953ada050f5dbeb169959fb67e1609b01765bf79935923b894968b"
    sha256 cellar: :any_skip_relocation, sonoma:         "451bfb2dc6ceb37e57329d15f8a248aef122df016c4dd7eee7f5be3ff4a57730"
    sha256 cellar: :any_skip_relocation, ventura:        "50b63301da39661652f2bbeab00291006c63ef03a22bcfe3c2ca2dc0ce25e617"
    sha256 cellar: :any_skip_relocation, monterey:       "7402b40b42e37de7f47ca4dd1a14c6ca8334abcf8050d53f5598d5472bb6d9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7974182325fb5477019adc8db9e89cfc1eb91b8392bfb78d7dcf25df13c49621"
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
