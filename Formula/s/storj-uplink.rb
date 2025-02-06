class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.121.3.tar.gz"
  sha256 "74c7589cf0b9fb2ea0f54d30cacd19ea15901441c38deff9b48d9683711066e6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2807005261fe39c69d8659a3201a847e7c442bad32665da8d1018c89de2eeeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2807005261fe39c69d8659a3201a847e7c442bad32665da8d1018c89de2eeeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2807005261fe39c69d8659a3201a847e7c442bad32665da8d1018c89de2eeeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "db4db6b700f4d84b33f80f01f0fc95abc7153239f7864db522e4f672b1aea2d2"
    sha256 cellar: :any_skip_relocation, ventura:       "db4db6b700f4d84b33f80f01f0fc95abc7153239f7864db522e4f672b1aea2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73f66c167abaa13197987d617ba4e50e72bc7eac73331287413af83782c0cf4"
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
