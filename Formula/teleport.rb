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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8353455d5a32339bfaf3c7253ec90d7c4913bd95457c22641bda6cc1a6f8992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf704753befa1d3ec97da4c4417be2aac9a937efc0add84c66a2de9f15316fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "6d1697e2ecf4284a1c833b3fbd1390c36ade9ea3fbd3e07f2af217cc56dd6be7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad2b4e87632a60540a9be2dcbe751c925eda84f363945c9826bd30d4144e8685"
    sha256 cellar: :any_skip_relocation, catalina:       "4f405c52edc0c505b76e00e2796bccb0d6e951a9a5dc837de576e28f5d97e3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf733042516fd8f82d8e5324c6886a2fdaf576058a9ad5072dc559074c07f7c0"
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
