class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.119.8.tar.gz"
  sha256 "18216b1e59ec670e8230bef8ecad8bca496a997644ecbebb0c7e8d10e82da8cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7e24b401cc43c4ed211a3c5a222e01308cb7d24563b3ed8997959268f4a255b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7e24b401cc43c4ed211a3c5a222e01308cb7d24563b3ed8997959268f4a255b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7e24b401cc43c4ed211a3c5a222e01308cb7d24563b3ed8997959268f4a255b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7026ce030878484234d650bc401863f4f682f581c5aa4010ca3aeb690532f51"
    sha256 cellar: :any_skip_relocation, ventura:       "d7026ce030878484234d650bc401863f4f682f581c5aa4010ca3aeb690532f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18538c07766786fe9bed85ebc2fc614e914267d4574e32decb458d48524a825d"
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
