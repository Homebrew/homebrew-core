class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.155.5.tar.gz"
  sha256 "3d32c003f93592b4072b77c1bc1048a71436c54806ceb021214140a70f308e45"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f302ecd1ab5f2dd243686b61b599230592df593507d8f9537752ac27e901ce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f302ecd1ab5f2dd243686b61b599230592df593507d8f9537752ac27e901ce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f302ecd1ab5f2dd243686b61b599230592df593507d8f9537752ac27e901ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9ab0f327c9de328812660202aad52d7b6a21ec2113f5ad609462e2be0adf97d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "296c5a447ece48789ab8fdc424775cdc5e4704c7c1873dc24bd94d3362b166c7"
    sha256 cellar: :any,                 x86_64_linux:  "a1488537c5e7b2416aa4ab6dfeca9709e10525ecb0b9a0a2eab19e674a4779a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
