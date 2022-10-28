class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.0.1.tar.gz"
  sha256 "07f311b764fd1b59d26c1600e4e1966f548a40bb265a70f5ffba12853b0c9751"
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
    sha256 cellar: :any,                 arm64_monterey: "3ecae96c1c7056ab8ea7b25106398064c3e2bec7e69fc8ed43f4c4b0dc4f9e28"
    sha256 cellar: :any,                 arm64_big_sur:  "e9619f7da6212a2684f8344879f009db271331b2717d7988e1328c4604beb676"
    sha256 cellar: :any,                 monterey:       "7d9eb46505bbdcbb21258307d627519339c3c1db4092d14cd793247d37b458b3"
    sha256 cellar: :any,                 big_sur:        "04231ff4b57f7531b98ed497b8d2a99d0f39407426fb840349f83bb1f68d0dc2"
    sha256 cellar: :any,                 catalina:       "21193f70be6a0f5084647f21fb7815429cb66cf7a4759c32a637a973403a8d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33231885abe10616888e83ffe3292327c92f2aef81f95f467e4ec7b2b738d4b3"
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
    url "https://github.com/gravitational/webassets/archive/53bae5e9307323dca1e506337dcaefd7cc1573a9.tar.gz"
    sha256 "adaa169996a2b6bc2c1d45ed2a380ea0c63e8d958b560741509df1590d5b93f8"
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
