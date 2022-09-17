class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.2.2.tar.gz"
  sha256 "aaa475f8538cffe443e6138a54cd6eebec54444a48fc70c761579832518736c6"
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
    sha256 cellar: :any,                 arm64_monterey: "9a5509842fa17b2ac05a123eb086e59a1c8b604c7520d62e547deecda611541e"
    sha256 cellar: :any,                 arm64_big_sur:  "e0ddf8c58f6ed1659da51e935f4ada16731c88cd746837381582f00e6005076b"
    sha256 cellar: :any,                 monterey:       "4fff14f80e1452fb319b7db0cdb3bd87aedf6458cb0416e22600a9e85e659e0c"
    sha256 cellar: :any,                 big_sur:        "047a340af16f26cb28a8ec8edab06551962819a1d9d35177e0b3c1badb1a47cb"
    sha256 cellar: :any,                 catalina:       "72d1d54e7d50ecbd77990fdb38c703ff1719b14bc3e07ab5d73e2cf72a44749d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf122f6a7be0edcd839ba8d9a4fc0da85fc8d09686d50aba49919234dfc2091"
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
