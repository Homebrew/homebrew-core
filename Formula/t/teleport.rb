class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v13.3.4.tar.gz"
  sha256 "e588bb3af7d8d0dea9d1162155dd63f3fb190a6c5b097862507b381a59076146"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95b53374c409f5f106763ff47362c927cd61c981694532725ee89d1b896a8c95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45d3e0050e940d6279751f33edb5a5fada7dbfd89714ca3a66e6a6b95129fe31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87d6a72977778318544213c7be7acf312774e500512aabfe0515071d97e66083"
    sha256 cellar: :any_skip_relocation, ventura:        "06242547e8c5172fbc0e573758d76353fc6ae131040296c2bc30847730b4b944"
    sha256 cellar: :any_skip_relocation, monterey:       "93fab58f4b3e83bd9b13daa9f754c0cc2b1135134c3754f08a078418e7c7538f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d794cbc3b6ba993d07b1df6e1435c2851c664b7fdfaec178ddab05e132cd8579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898ca6aef553a86c1c31d67864aa788bcb1554ae63bcf13aac1ffe89efbed5c9"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
