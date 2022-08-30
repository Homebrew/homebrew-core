class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.1.7.tar.gz"
  sha256 "3acc97b7283455b53d6d4ee0f50e76c974e812d2b3f7834a4cc94ab8164fea4b"
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
    sha256 cellar: :any,                 arm64_monterey: "c378b8315a78cea6a9c8725fd15cea158e3895de7fa94e5ef3479e9ed8d5e6a5"
    sha256 cellar: :any,                 arm64_big_sur:  "a003fa660bba52485994643769cbf7dee3bfd14b6492855fa3a5ecfdacc8c174"
    sha256 cellar: :any,                 monterey:       "3b5f0abcdf8ae39349ed61eba4e271ed74339ec27771b2aa1d0c49e442cc7173"
    sha256 cellar: :any,                 big_sur:        "cdc99edc3dc7f6c72b3541eb9b2aa44c6df2a5c78ef94aa520df5f096defcff9"
    sha256 cellar: :any,                 catalina:       "cf92b61d3f97fc0a7e487e1d5f699db90ce7459825692d8e1e9f0312ace7f05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9a09d5744667ce5f2c03e6586be128d11ec84f841c686c4cbc1c9cd9f48f0af"
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
