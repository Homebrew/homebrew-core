class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.2.1.tar.gz"
  sha256 "0347f86d530fbd8baa0a91e9b66dd2da3ed7e9de2ddfb330a3e28c1ea75c3406"
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
    sha256 cellar: :any,                 arm64_ventura:  "62eec77b550289029e77208d19b16fa719b2319068ab04db1aba2b4226760a4d"
    sha256 cellar: :any,                 arm64_monterey: "61b8288a6325b8b69ab6ef867319c164b599e55de11974f4fab951d8b36d5c88"
    sha256 cellar: :any,                 arm64_big_sur:  "bfd4840cc11a513eeb59bc1dc20a6db03c87d39e3463739e21578934a1bd896e"
    sha256 cellar: :any,                 ventura:        "67b2c52366829ad60be0765c121f6384942808af33ff38700bbcf4430847d729"
    sha256 cellar: :any,                 monterey:       "b8e51b8b20a3b0ef48baa627c251939000eceb5e598bf2bd02af816aba48ef73"
    sha256 cellar: :any,                 big_sur:        "3046986126f2b2d8a8d6805494d24f25684d029483c22028291e23de61a19a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c8461242a3379e79cf0ebe500ebd93bcada93a5c81fe06527456ba17a58e15"
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
    url "https://github.com/gravitational/webassets/archive/583ca4d3afaf83109f999889caece5f249d7b602.tar.gz"
    sha256 "92c85604c09fe6070ea8d5cf0388dd109dcc2ca5757822576d2672a92cd547e3"
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
