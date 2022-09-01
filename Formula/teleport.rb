class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.1.9.tar.gz"
  sha256 "336fff250f06f7c58be90c30ccd1f4f9e6dd59e6da29c309d490c9ff8ba02880"
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
    sha256 cellar: :any,                 arm64_monterey: "a13b605de63354a8fbb2f8399c3bdb89f6f5f88a74bcc0195847aa297e762ef4"
    sha256 cellar: :any,                 arm64_big_sur:  "3471250a2f12792029cd82770763271226b209a063a496f3ab1364e1bd9a33c3"
    sha256 cellar: :any,                 monterey:       "e94874cee8424e70c7840a6e8d7a08ebd690a993187f4d07b17cc095add8c4f2"
    sha256 cellar: :any,                 big_sur:        "bcfc9d620d3feff35a5359d1bfff55535995464d857ca98d9eb2a9ffacd352d4"
    sha256 cellar: :any,                 catalina:       "7b254618351045fbb999477964165162193a554e123a8ecb13655e077d75c9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "929aa36555de1d83a852747351235a50c466e4934dbf86e5bef86f46de648cb8"
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
    url "https://github.com/gravitational/webassets/archive/0b609ca4e8a3ab324713d1ceac99a25dd7e571cf.tar.gz"
    sha256 "855fb273e5c466023162c824c21630768bdee68f4d15e6f26365431a2bae0949"
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
