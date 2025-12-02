class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.142.7.tar.gz"
  sha256 "aecf0b7747bca195de84b9ca8737f4f1a188ed9faf6dba7c65e06914e435aa68"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6436f763605f844a7d294d5081066e1540eb2a1c3084a43a44b0224e75ca531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6436f763605f844a7d294d5081066e1540eb2a1c3084a43a44b0224e75ca531"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6436f763605f844a7d294d5081066e1540eb2a1c3084a43a44b0224e75ca531"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd938598b8970e2b2922eb5a7e6721e8da1c122335b97ca1768e5b69a6e26d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67daaf24c39277c6ca087bc76572d18355b0574b569973fbe8cb8243005a6f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cef7bf755e08521ca3e7d3781d08703837bd93eff7a695214b4e9822bd1a465"
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
