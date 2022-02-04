class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.1.3.tar.gz"
  sha256 "80e686faabe7b0090ebb8f0c9971fb5f1d8fd429131f1390ccfbf6ea9666ccaa"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ef203efbaa3ede9ffebd56e872413b73c2a3745331ffb848bc671586647b24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1a5a208dd13e4e2bd7a9f4a53b12a1397d3bbd62bd45a893c52c9f8c6f4b4b1"
    sha256 cellar: :any_skip_relocation, monterey:       "cfac473d5f9b5beb58917a62bfa4979d53b6ceb75069e4951145661565c2e9e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbdaa2b8fada4a78f3f0f03664b6878391c6668cd02cd94554869f9920093f4e"
    sha256 cellar: :any_skip_relocation, catalina:       "10ae0cb573153198a2d6fbb15afec9af7a5017d7a638df4064f15c5d39568486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a851ddd6d8cd571b2d94f43af76150c2d886d16368623d5e706dc12abbc8798"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/ea3c67c941c56cfb6c228612e88100df09fb6f9c.tar.gz"
    sha256 "66812b99e4cc00d34fb2b022ffe9d5e13abb740a165fcf3f518dada52c631c51"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    webassets = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match resource("webassets").version.to_s, webassets
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
