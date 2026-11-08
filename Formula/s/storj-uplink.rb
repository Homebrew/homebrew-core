class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.166.2.tar.gz"
  sha256 "2e188a8aaf1100b034d820c81076482158c930aed6e63ea3f04aefbe9dda6ff8"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "451aadd2452bb1005bcaa757ae64ac033d8e10005b903f675bb977205799ef3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "451aadd2452bb1005bcaa757ae64ac033d8e10005b903f675bb977205799ef3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "451aadd2452bb1005bcaa757ae64ac033d8e10005b903f675bb977205799ef3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "30c52284c0d37442f8c61d6a356c028f5bfd43ac980fb9d607518aa8db7ecad7"
    sha256 cellar: :any,                 x86_64_linux:      "0f8dd33d9c24ac8c2391f857137faaf29f7aeaa129e53641ffae6b6ea6140206"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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
