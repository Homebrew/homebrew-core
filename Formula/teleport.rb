class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.1.2.tar.gz"
  sha256 "6e128bdbdf3252e67b91a280537eeed6543c59f87759d06e35cfdc982d61a1eb"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67099fb06bdf0c699a8f7d302e6bc8fb297a4d90b86f0756ef30a9e441a2ed9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6d11608240db6a83af5e962f237328fa7e1fe0606d93da341e90223ba71c666"
    sha256 cellar: :any_skip_relocation, monterey:       "06950ed6b0801bff97b50a032a21977581d78635db19b127ab39d673dd3a4efa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6344634bf7dd926808a62a2c294207109589e2144ec4a7548d597b6954197a24"
    sha256 cellar: :any_skip_relocation, catalina:       "34af518fd9d85df415f9759339d2f3a53dade78a8f1f164aeb2b881538a2dcc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8823fe9bc9e740aad07e16a5a360fa17a72c29505642bdc704339774610e4330"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/36ba49bb58dd6933d5ed5c9599e86d2b6c828137.tar.gz"
    sha256 "5a61ff497adaa769cd5ec0a2e1683cb79aa4f0cfe539e3e1a91a85c3f96d24fb"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
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
