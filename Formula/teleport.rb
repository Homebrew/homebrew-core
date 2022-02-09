class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.2.0.tar.gz"
  sha256 "7f0d92605eb84a58ba1f293251ceb95f8c40e9b2ad08098dd9cdff9fb586a55e"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b1a24bf36c7d774fb09cf97f605910d8fceb43dfb8deb596b70551ad3316dcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d934f066ef77eda0a18ffff9d255be8ca18d31b5e3cfe632349b35d3b4a4240a"
    sha256 cellar: :any_skip_relocation, monterey:       "ada30272d14ba4cdec1b78c775b0481e9e615791dd2ed28230a3300caf324a6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e4a4ed891f55a81da209a62f425f4e2b84827059c6466a89e7ec901024a9e3e"
    sha256 cellar: :any_skip_relocation, catalina:       "4c86e9568ec697f42a4c0d1f2dfd74a238fb7cd7447b661bc111abfdd5fdfdf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5525aa21d6665662484aec421f446b2e67b7ee0a627d63bb3eaa7b025e082fb0"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/187a1f13821b2b33a4312a10af216963175c3d40.tar.gz"
    sha256 "c0ced56af408ac905c90a2afde3bda1301423ed08cb63149d69266b62c19297e"
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
