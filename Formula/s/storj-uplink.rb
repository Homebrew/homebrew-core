class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.132.7.tar.gz"
  sha256 "8a1ac7683fb5d588e66f789e16d70d85dbd4952861f41d3681c7bb191cbe3dbb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da4208fa15d52c2a5e132bc13d5da0f9cc3b7731b16796b380ceefd4c9033ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da4208fa15d52c2a5e132bc13d5da0f9cc3b7731b16796b380ceefd4c9033ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2da4208fa15d52c2a5e132bc13d5da0f9cc3b7731b16796b380ceefd4c9033ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "59973b12014d7faff7eb6f2e4a549aa6f45a6cb098f3cd791c87fa115b0bbf6f"
    sha256 cellar: :any_skip_relocation, ventura:       "59973b12014d7faff7eb6f2e4a549aa6f45a6cb098f3cd791c87fa115b0bbf6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fcf373fe03fba0fff3457e4de5aa3a66739c59b97c9cb3cc205d0e27b0b30b3"
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
