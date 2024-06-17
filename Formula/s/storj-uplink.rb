class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.105.2.tar.gz"
  sha256 "e60baecd976935cbbbfad79a27a6d1b4734a2e20e69a116f8daf5ee88ea8cea1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9accacd167bcfbbcaa163e28498f92e8ed7e5e4e17b48d3cdd22dcc14af5e376"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc85e1f4be7755e203549dd9c66ac307ed551a15b7c645c0fb6e770a2766ccc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa47e7bcf8c256601082a23a84179136fd6ada060e19c05f8699b57b9e4abde7"
    sha256 cellar: :any_skip_relocation, sonoma:         "20e9443fa68ddfc78cafe3a536f8f987f5e0a0a650bd8239ac43195be40bb029"
    sha256 cellar: :any_skip_relocation, ventura:        "068ddba797a2dba7de99e5e18ccbafef3bdecbc7f4c5a19ebfbb23925e017614"
    sha256 cellar: :any_skip_relocation, monterey:       "295db16fbda2409685e0fd97738eb4e5fa69ca63c6157e8a1b8894b8ed2940df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a4c196b089637c0a9c301d8e9e6ea3908357d78d19b01d9bb13544e8da4124"
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
