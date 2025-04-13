class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.126.2.tar.gz"
  sha256 "b846f2db3c03affb2eb6666692782ad11e04f3aed1a5668956778b5d89cbd8fe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c945fd1800deaed6a41c6b4e553a3d5736d76bb05fb695bad0a61a1893bd1e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c945fd1800deaed6a41c6b4e553a3d5736d76bb05fb695bad0a61a1893bd1e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c945fd1800deaed6a41c6b4e553a3d5736d76bb05fb695bad0a61a1893bd1e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "16fcbb5e429117b752638e1d1a377bbb1eba954440ff45fca49e9795afb5be6c"
    sha256 cellar: :any_skip_relocation, ventura:       "16fcbb5e429117b752638e1d1a377bbb1eba954440ff45fca49e9795afb5be6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2285439e1ffdc988d06d9368811578601e57f06f2e47e7c6478424d3fc776e14"
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
