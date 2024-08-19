class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v14.3.3.tar.gz"
  sha256 "c30cefedae3df3cacef78e385a369773820f9ed00432b3c1bd12b0026b01f144"
  license "AGPL-3.0-or-later"
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
    sha256 cellar: :any,                 arm64_sonoma:   "327c97012b954c9e17e46926ff6d46e919bc9a32ca55ccf9dce95e0bf1c1b8b0"
    sha256 cellar: :any,                 arm64_ventura:  "f569c4a8b34f93e23bb76d05e76df1b16b22f7a8cc36c2d9916e67c7873be825"
    sha256 cellar: :any,                 arm64_monterey: "4e7c7c7d068bf972f65dff941b457db1a663cf26ac163e274a303ccfd6b4759b"
    sha256 cellar: :any,                 sonoma:         "04bf1dceb7b1dc5864dd0c7f9e192fb0972791f3c9ee9be9e7914ae9471f1101"
    sha256 cellar: :any,                 ventura:        "1283a664b51ebfc02a78163ba49739a6d990ec023f1898b7dba672cccfb60362"
    sha256 cellar: :any,                 monterey:       "5f098515fa8e90a07e8274e44fb1ad24cb61db1fa74ed10106d78c82d4f4677d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906b35b2c7dcc5bed2b1a9897b2464b113ba6c568340f3a193cfc665f041831a"
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
  conflicts_with "tctl", because: "both install `tctl` binaries"

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
