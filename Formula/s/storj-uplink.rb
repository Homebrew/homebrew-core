class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.152.6.tar.gz"
  sha256 "90c980b303ca446a3e1b0973b076f1246a20967b0806e97efce2defe3fc7bb26"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7260ff3c311de21f0ddc9b7e8a861474d62b446d10c52a2a2e0b7a03271614a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7260ff3c311de21f0ddc9b7e8a861474d62b446d10c52a2a2e0b7a03271614a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7260ff3c311de21f0ddc9b7e8a861474d62b446d10c52a2a2e0b7a03271614a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "97da61561cbcd16d50677a6d1eed6f133153c84aa7fe31a6087927de115effae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970704bb109c55f4b1a6bca0b31c2787b3565ce1430816a3a0cf084d9166504a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c33792356977a8aa4cc9b77d10d45291c694eb2ccbaa5ce0f39feaac2f35c87"
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
