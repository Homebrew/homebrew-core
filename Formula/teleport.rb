class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.3.0.tar.gz"
  sha256 "242ee0ed1ed01a328866956df12fd4567b070069cfaa605d4f59275acc390c31"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "473ce004402dc996084ee240e331f156516c5857fe686c2b8223289dff9f30d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "854ff71b86bd2bd1966163941b4e4cd95cdcc84c146ea31e7bed67780383da1d"
    sha256 cellar: :any_skip_relocation, monterey:       "5efe375fc4dd90707f6c159c83f3f9a85797efc84f77b462cbf8292e607c17c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a81f41b92207aeb3904a288c24318d632eb83bca50c669508bb4baa8aa27bee7"
    sha256 cellar: :any_skip_relocation, catalina:       "f7eb8d93769a03dd9192ea701c91a58e5307f5322cd957d8d1b60264b1abe511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3bb7ca88c89a7a59dbe50b71ddff95d894a78a70e00e912b5e290038d633151"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/763ddfa16d2a2d8f4b1d24a7d6b9591c0677a20c.tar.gz"
    sha256 "033d77412d34c6cc72a1545c74cf3f56a32c6ef0dc2d6a64ea2dcf9de1c88eaf"
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
