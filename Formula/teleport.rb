class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.0.2.tar.gz"
  sha256 "c843ea347c79ff8707b65d578e38f0faae6e27c0c88cb66b3266f7272070c0a5"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a65589b4fc91c8602211f628b53c9f0390cbe9041eda569a739a917932c8ef0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7934b866289673e88f195c4b186938f05b31974f32b641721fdb429c4c8f0728"
    sha256 cellar: :any_skip_relocation, monterey:       "f16fbdc5c71ae93833fd04fd479475c82b3c7f93b6e1f9e4e5610c9bbc3c3446"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a09671566a90c0a495f74c5aac5c92e89324dc913d9ab67c5eb177bf79073b1"
    sha256 cellar: :any_skip_relocation, catalina:       "3cfe33d8be9923607c42cee84c450545968f6cf1bac6a2fecafab4bfc14a28e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "602323d343550bef72da13e776efd9958e735ab115e72b03402fa08ea2629324"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/dae01015ca8e1310734e92faadd13e77844b7547.tar.gz"
    sha256 "9e15a80a055c0496bab93ca079abcd9ddff47eb43b4ebbb949d2797fcbbe3711"
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
