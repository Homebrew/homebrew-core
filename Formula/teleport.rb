class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.3.5.tar.gz"
  sha256 "c403bf19e6c6f227cd053e9e11c7d205bdb428ef3780b4cb4ddcadfa5314b1d0"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135c2b27ca3f8dc0c85e5506ad984c79f4a467cd5b9bbea01ea2daa1e8e5f68d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bc257e957d67e736770e8464358af95f09d50253c99802c8adb30e925616f94"
    sha256 cellar: :any_skip_relocation, monterey:       "13253458f86b4472972bf6f0a8b6bbb2ab74ce2307c3eae312fd551a12559136"
    sha256 cellar: :any_skip_relocation, big_sur:        "678351ae8fca8e4979f8f1eb98db2fd4ebfea0faad816148c582a5b7fcbbf39a"
    sha256 cellar: :any_skip_relocation, catalina:       "8563fa4aa1efe1949386c6c13f56df4b88032a8e10d2bdf090748ac8ba2dc65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "596f73af661e5288976e1f9000dfd5962643cfc72d4cb7332b55de96b2e455cf"
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
