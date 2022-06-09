class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.3.4.tar.gz"
  sha256 "4561a069e87ab9e9cededa12b8ba1e7373b8aba47ebf48c6f3c02c8b23a0ccd0"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a247ebe0388918cdff87a1564be82b212032016f24f6898eaf71a0ef07138908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17625cf6fda10672dcb8457cc75a568617cbb9f60ca5c380138bfe15ed6b211c"
    sha256 cellar: :any_skip_relocation, monterey:       "29fdaefb91a01a2f4977368ac2bc3ac58b1851d86a9461d985eb3c37af51ade1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c7f9ec29e92ae48b20e379d2849b176c59f724bd3bf10a336085234cd876b4c"
    sha256 cellar: :any_skip_relocation, catalina:       "6e3ba9f492167d7040b463fd87ab69948c2503134a458916006cfb3454637723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b40ab86d953e1b3fa33cfe514275e4c2ce2f2f19812cbf473c7c02611f19ea"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/127343ad29e2f42704c2c2ebe4c98b579185d25b.tar.gz"
    sha256 "bb6c70f45360c40522bc9cd919af39358fda62686395cae6c5274cc6e73501c4"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
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
