class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.2.0.tar.gz"
  sha256 "2b5b049d8630b443559103f999f5263a249f4ef3a8acb6b42c5e7163a551d3cb"
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
    sha256 cellar: :any,                 arm64_monterey: "fe00600869921b799cd04cc5ce0656e5ee082cf72c89de3ad9a65a5f7c0e1949"
    sha256 cellar: :any,                 arm64_big_sur:  "a2bd7b9580e8e42f14382eba489c204af958c85f61a50d29893a93d4d9f34992"
    sha256 cellar: :any,                 monterey:       "82b3fe7d6a304a05e4779131116229a9b066255c799b427e2d7ae0b5bc6cc222"
    sha256 cellar: :any,                 big_sur:        "8d66aeaba897c7ae2c7d342bc899adc23218c14ed59f7f4046203f53f2ead38a"
    sha256 cellar: :any,                 catalina:       "9bcb22e6105a8e5911966f4d58b604650cc558be0a727392b7dea35d3d1f0221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "813ede66003156823a0521b08e9b9a581b6a51acf191261b3f0dc4b5749b8449"
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
