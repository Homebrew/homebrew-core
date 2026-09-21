class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.163.4.tar.gz"
  sha256 "952fa603e68dd86a20d4d434217027b0dd1d6f91a274908d8a4572cf4794ff82"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cc3d291a3cc3ccb3c40ebb76fcd299db0bc85970e3d0aa2bd436e0d18f82fb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cc3d291a3cc3ccb3c40ebb76fcd299db0bc85970e3d0aa2bd436e0d18f82fb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cc3d291a3cc3ccb3c40ebb76fcd299db0bc85970e3d0aa2bd436e0d18f82fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5cc3d291a3cc3ccb3c40ebb76fcd299db0bc85970e3d0aa2bd436e0d18f82fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8134d433473525d8791cf1f11fbe486a0ad0e2cc4140086cd7689a5033ab6494"
    sha256 cellar: :any,                 x86_64_linux:      "505c8d04129c4f6f2f0cc9690441e9be79ac592220aee8487d15809868673aff"
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
