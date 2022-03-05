class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.3.4.tar.gz"
  sha256 "52808ecce11fd1470bd4752bfd1daf63b66349087d9535645ac5093ee307771f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b9ac17c38e53a1c6c1ae304bda627ff07c3dab73736a54593c5a81dbcc0b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbef46857e0a884a6048de82a969ec11979076a8f27853ca0ae8ed9ed391fb32"
    sha256 cellar: :any_skip_relocation, monterey:       "343e7e32ac3c676a27a102a2ff2cbc96acd2981e5e417d61255ec35c024d5721"
    sha256 cellar: :any_skip_relocation, big_sur:        "81284adf7b2fb99c2ed834ae6f1815744075bc53f3d379247855c8829509672d"
    sha256 cellar: :any_skip_relocation, catalina:       "705a301f7abc3a280c9dfa2d564026c6fc140191af412e3d49f22bb9bb157251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fccd59e2f346d685dd7bd00d33bdc9772b3e0bde623b5e2aa4cf8514e2fec69"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/ece955d1ac7e074e899becb3d8e6b5376cc1594d.tar.gz"
    sha256 "f7d4f301f395be318fb34b98f355ec023d1ca09127d2932f6767a2254f3843c8"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    webassets_version = JSON.parse(curl_output)["sha"]
    assert_match webassets_version, resource("webassets").url
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
