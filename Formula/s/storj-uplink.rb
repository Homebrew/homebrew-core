class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.138.2.tar.gz"
  sha256 "946ad128485d71af76583d8524e6784fdc941c6cc5ec270701a8761ef1be0f4b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "800d4479d2383465a7ace26c5365621f72484143d4b1078bc0a7812da772a507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "800d4479d2383465a7ace26c5365621f72484143d4b1078bc0a7812da772a507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "800d4479d2383465a7ace26c5365621f72484143d4b1078bc0a7812da772a507"
    sha256 cellar: :any_skip_relocation, sonoma:        "858c22e7980a7ac744c5ab5d047a25a8361836e637c28b362bef66a5182245bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13f5ea0e8d09e00b95531798c3cd13bb97f1abbeff584d9d53193c7fa5293cd5"
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
