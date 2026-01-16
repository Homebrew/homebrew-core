class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.145.3.tar.gz"
  sha256 "9f7b8af602cf92c1dc0fa675feadbd8d322a97e25de1f9f3de8ccefd5ef48b12"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2e69e9cac1a441dc62587ad4df7440cf05668f85cca84fe6462130a34a22424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e69e9cac1a441dc62587ad4df7440cf05668f85cca84fe6462130a34a22424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e69e9cac1a441dc62587ad4df7440cf05668f85cca84fe6462130a34a22424"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c9e276a0bd3325408b240db668c3c93c0d87c5ddb3e87b429cb708d7b7a7022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b371232a18d36cdd05917bc438c6aeb18e483a974288bebef10cebdc9e4e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d904212bd130852fa45e2f7c9a5f0592dc578a2cb459c9a8894d9b2c1efd3236"
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
