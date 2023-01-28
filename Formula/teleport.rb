class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.3.1.tar.gz"
  sha256 "707b4226410fd81b8fdfc3e06b45d0cd573872fe9eb74caebf1d73f78dbe681d"
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
    sha256 cellar: :any,                 arm64_ventura:  "2975291532419ff07d22f51bc0a07c8ad53b9f2b72de90a508cce2e5d6d93919"
    sha256 cellar: :any,                 arm64_monterey: "4bc4ea2ae97a40367a0407cd3212c63c94ef7542e1c301fe4459de453c59fe78"
    sha256 cellar: :any,                 arm64_big_sur:  "1eb2bbab86f4e9a78dfa30abe655b24f06c6a43d3a470138715af759a7ef2a16"
    sha256 cellar: :any,                 ventura:        "09c568f5c8072e097e262baa069c594fb74d5c80c628915bedf8b21c9078a7bb"
    sha256 cellar: :any,                 monterey:       "1ce64b7ff57aa8dc68767f2cfe5260fadcfb55f5b1327ea2d7081208a86e6c54"
    sha256 cellar: :any,                 big_sur:        "53fec3d9442ac91cca295126e1752f762b0587316aeb11a6fbdb605854f1b9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "921617407b305cc031402640317dd3baad764fee429b111decc23e2703fbac22"
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
    url "https://github.com/gravitational/webassets/archive/5c619e15216a9a3b06ef517d44292f0443f8674f.tar.gz"
    sha256 "e3070df51ff01cc3297cbc7998b4cfb2e26db9d602a58233c89e89dfcfdd5d0d"
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
