class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.0.1.tar.gz"
  sha256 "da01fd3e94a6c813bd1347db507c7757bae6d459b12bcf390fd8de0790a47151"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09675811886217096342e0aef75e9a4e3b22df035e4a2bc25b96e59cff814c9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9339053e060bde18735aef74747c91aaaf9c4244dd147ffe5d42ec3781fc6151"
    sha256 cellar: :any_skip_relocation, monterey:       "9534e4d08e5a43793f46cebe74187540c65bc889f6472b57043080e772fab5a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad7a93176b31a1f45a7da78ada9745e729187e6dc74648b263870f66a4b24356"
    sha256 cellar: :any_skip_relocation, catalina:       "aacd525ff11a13db835366d425bfe6ee09bf35d70b3e54788a1da57b9458f18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a3a5ead6303167af4cfdcaa8e9b1553fe94b17960b8937eaf003426dc5e0fa3"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/db2dbcfaba9e35b00bdfda1415a42f086caf5b5e.tar.gz"
    sha256 "7e875ad361d3d75fd89d2738c5d97ec84c7e6c8d9a4221de03aded80fc3c8411"
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
