class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.3.3.tar.gz"
  sha256 "ff041a373ff52814382de51230164b79bf19d5381a9b1b3a8fe5603c074cb7af"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c09cd1a246a88b8144fc178ac1fe9cf80a9b71f8ecac819cdcdecf46e448bd30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d9a2402841fe92fe4e3c541e22d7c2d47055f01a619cc660573397b81f03c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "180e41ed8e86761a1bdf39ed79420a48750eb082471b0d5d2ae3c40b81a44aff"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f8b3b71bfdb8554723335a001f75dc1fbafdb9dd69794e2d3e43cf7c3be3f39"
    sha256 cellar: :any_skip_relocation, catalina:       "79903e7e7335e6a85135dfdac6bc4881a467f693ebaf0dedabb7cb3fb1bd0c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f25e6ea84ae7c0fcecafb276fdb4037d2e2b5934e5f13f4431a525e92d3f9a4"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/ece955d1ac7e074e899becb3d8e6b5376cc1594d.tar.gz"
    sha256 "f7d4f301f395be318fb34b98f355ec023d1ca09127d2932f6767a2254f3843c8"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    webassets_version = JSON.parse(curl_output)["sha"]
    assert_match webassets_version, resource("webassets").url
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
