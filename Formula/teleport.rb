class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.2.1.tar.gz"
  sha256 "c0b6de4a9d1b32be9c6f8af8a0c0cdb437bc72b5305bed1ee410dca9b42caa24"
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
    sha256 cellar: :any,                 arm64_monterey: "09791bc677511c2b8c1a41598d123a009fc836fa7bf00c2e2c05649095878c6e"
    sha256 cellar: :any,                 arm64_big_sur:  "f8e0ceafa7e6fe54bfd55bc91c268728dfc42811a77256b20ba4cb6a3e974523"
    sha256 cellar: :any,                 monterey:       "4fe384f47fb2b6eafa28cbb9ace4a4dbf6d27c9a14cd6469b7e6c1b949dc408a"
    sha256 cellar: :any,                 big_sur:        "3bfe1c70663371bbe2fb7bbe5ba5c322b643725d13f2e2ffeb62275e0ce34aec"
    sha256 cellar: :any,                 catalina:       "a0b936c3648f8b5aebb01d7c6f617bc980b3ceba91c87a4b451e6cbd0715cc07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b632dae0814c30aae1773489e7818f62f6a142a763e9df6f137f422dc9f0932c"
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
    url "https://github.com/gravitational/webassets/archive/e42ac15dbc20b8e302187a4ad9cf2ce95df2e7ae.tar.gz"
    sha256 "78308ce7d724da0b7004d23061e8cd8b4132150797b15c24fff85327427a93bf"
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
