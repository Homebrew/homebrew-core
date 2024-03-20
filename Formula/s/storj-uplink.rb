class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.100.4.tar.gz"
  sha256 "78ab66beef6641dc74b0e8a0fb34113d4c6a27f77af6842012f33589a3ef87a9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b7cfc77df6d4ca389722e478d182d1eb674f81f16baf4afdb1515c7fac1dabd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f6014bc92b167f5338c1e7f174233e68e3b1a97fc6c13f3dfdd2817143ef651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ebf8183a0d5c922a0acc64339dbfc3d99b73f42d528006ea014386a48fd4423"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d0dfcbe7896683b1315c2d092d0b5857ee327e17f49b80ccf5aabe5c7a68fca"
    sha256 cellar: :any_skip_relocation, ventura:        "66f7532e117de4952121029cbfa5141d716d117afdd23744713a98dbb2c6f4c2"
    sha256 cellar: :any_skip_relocation, monterey:       "04ff54ba5c6f3d0045a99cb4ce759f89ac16f44c26a2476cfc6cd2f99fabae46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4eeb4c6cea4855a7c1e8c18a155239c3b55b000284dcbac07c905c3c75dbbce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
