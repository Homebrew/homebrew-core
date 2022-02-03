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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "343ac78a9f23a746a238b9e1d0c31ec464ff0553ed2587dd5f2d437fcc8258c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d679e10ce24917ff24a008dabc65ca701d0470f4bc8ecb3c49e83c929842613f"
    sha256 cellar: :any_skip_relocation, monterey:       "937a2b0ad9bc31f0d216991b385b272c32dc3a6152da68694b820a483f21f720"
    sha256 cellar: :any_skip_relocation, big_sur:        "a87a68acd4503e6bdfe895ac95c7a1009073dfc04ed0699427ac98999b696d40"
    sha256 cellar: :any_skip_relocation, catalina:       "43b56c268429b1a767c62f2f73604b87d3e0bcbc9037e7be1baf4d00943d9d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e0c847292c3a190830c549f7fcb65667f2d42f9dcc31ec1e03de891d27952f"
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
