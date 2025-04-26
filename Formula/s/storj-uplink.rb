class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.127.1.tar.gz"
  sha256 "5522ca2e6c446c68216e868adfc3dc8c0dd78d3703cefe0451a480afea2b9630"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0543b821faa8d52554d9ea34fe37be5320b6be7d4b53276c9b1a37387214e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0543b821faa8d52554d9ea34fe37be5320b6be7d4b53276c9b1a37387214e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0543b821faa8d52554d9ea34fe37be5320b6be7d4b53276c9b1a37387214e17"
    sha256 cellar: :any_skip_relocation, sonoma:        "599421d64cd8b83574f283b587521b88328b3d8dcbe68c7293dabb045345e637"
    sha256 cellar: :any_skip_relocation, ventura:       "599421d64cd8b83574f283b587521b88328b3d8dcbe68c7293dabb045345e637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87b0de0d635f59fc77902c12e140c2d2523b8db325d06f2520ec658d5202d03e"
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
