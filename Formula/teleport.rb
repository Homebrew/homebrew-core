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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b70126af602c526f600d04d8fca1d9c12e13f6fec26c9d6405488b057a41e6e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ba7bf06f4287b01fb2a448b4e275091ae2c9031dead0ebbccdaf6729c961f91"
    sha256 cellar: :any_skip_relocation, monterey:       "fc3924a2e1f25689c0b424f280602c05859803ec7dd143bb21cf81c69f5bb98d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d1391aa21917a42f146dd2a8560eaf91c89924832bcd0c233b92bea0bdab820"
    sha256 cellar: :any_skip_relocation, catalina:       "e68b50974d8412f9209acd484e2d4f3c903070f57aa014737d191b703704fbeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b0087affa2c631bfbf172ee2b16de1ee7a1610c454b438e2690c28c226c501"
  end

  depends_on "go" => :build
  depends_on "libfido2"

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
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
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
