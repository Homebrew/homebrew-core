class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.3.2.tar.gz"
  sha256 "e830ceb17cd27b61cb50f1aadf87697179f714b2f9ff81fff0746b41c9d70845"
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
    sha256 cellar: :any,                 arm64_monterey: "a95ecfb8b63d4c2b4f1eb738619e835d23d0829fc0d9e15aa470dfb2ea055728"
    sha256 cellar: :any,                 arm64_big_sur:  "9f105ad4c98552f29d385496ee5e76ebe12f96e1175b743aaa315f3668c9fde5"
    sha256 cellar: :any,                 monterey:       "ef88c0f883a1902902da5073da24a11bcb5eee097257e5daa013afc1917b5fc0"
    sha256 cellar: :any,                 big_sur:        "380f8a40a6d988d0c5205d01e73152944027f596127b4d3881cfe5565fbf637d"
    sha256 cellar: :any,                 catalina:       "7f37e444691cd74f1461e85709f812a00c5abb9bef5012e29d03edcbf757743c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fba55d70223537e0f06b2c4ee170311ba7926503ccba8bd0876c9e2d23bb362"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/c4f689e451bc0b389ec3b8833b33997fa55d949c.tar.gz"
    sha256 "6df41b234508bdf086cfb523247397a0b1d54642fe8d18a09d5a9353d1cbb67a"
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
