class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.2.3.tar.gz"
  sha256 "6a48cea761b45e582feca1a76f3f905ca982b9d597f845894d7c29c21bfb04c6"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8311818f6e8e0f4c1101659ad55855471475a1576023cbcff0829a644142bcf4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d94641055b4b75eaeacabe12330bdb8eab7189a98fe3143453cfb15534c331c"
    sha256 cellar: :any_skip_relocation, monterey:       "ee50cbcb0784cd66cd39f25d82a5d3684c4192617a0981a187f7729ccbae4b41"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b53778c0fb5a348ad0c82ec4cb778efec8ce3951e667981abe0ad003199b8c7"
    sha256 cellar: :any_skip_relocation, catalina:       "ed6ff38696d051a4def2cbbb2901fa0ed9fd97cf175f76ba8f106a38114f78a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d7aa61adc28ee3bd8700a894ba954661bbe3c8b8c34cf37014454d9fcf1f73"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/4c555ddd7f4e8c6d74dd1ac467db5d17ad5c4ecc.tar.gz"
    sha256 "00ba592b9a5f790e115d41a2a42127b178b75a362292b68b40577881a0984b19"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
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
