class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.2.2.tar.gz"
  sha256 "6fea4dcfe6e1f70bd5df203238ecbf978d870ffb9adcafbf4db3f5991bcb9c0f"
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
    sha256 cellar: :any,                 arm64_ventura:  "4422481bf82774af65ed3b54011ba9b1ea3b062f65ec4149cf1c9941eecf6281"
    sha256 cellar: :any,                 arm64_monterey: "326a5dce709423bea7dec28574931b78a1c1dd1412aad1eb57f61dd58f9e40c4"
    sha256 cellar: :any,                 arm64_big_sur:  "54cc5f5ed2f486cd6aacab74bae7e790584de8afc60401787eebf004faf7ad4e"
    sha256 cellar: :any,                 ventura:        "fd9677443d1d50aff46c5013a7442715f11056daa482fb4509b9a275d56f3f68"
    sha256 cellar: :any,                 monterey:       "68d9b8737b765ff152263aac00f123854ee9908cb02fb411c6cb945b0923cad0"
    sha256 cellar: :any,                 big_sur:        "5a2766ad04fe75501ebe6fa35734c28b0710ecb13a614d6bae5a3c9ec71c1a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6cd0399122e302f7a124bc1ce523865b1361fab21072912bd1c8f343b50897f"
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
    url "https://github.com/gravitational/webassets/archive/0b47033b29153248e870b791bdc0714e0e034c9d.tar.gz"
    sha256 "f3444fbb2060bd8891267f45a8115e2bc1a0a346cdae1b8c1c37cd105b5652b9"
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
