class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.1.0.tar.gz"
  sha256 "3687343cf46cd9d03a38035f02f4d826945402fafa8fd8c2566ef8d413eea829"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d38dff787d83873e48522745780d3923123a08168a415fb63173fa1e64ed2ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e43651f8681367b9548e36b9b0b3613e2f58173e7a977bb11763e748d88b72a9"
    sha256 cellar: :any_skip_relocation, monterey:       "9155c0f8b025a5ab849c72d7549554a7ece1efbd270325fa7b40ebfddc857135"
    sha256 cellar: :any_skip_relocation, big_sur:        "26146dddb4bd5b28b33a815a783eb3169f40b2aa48ef2825bbf092f0f6fa5762"
    sha256 cellar: :any_skip_relocation, catalina:       "45786b311633ac6275841ba9fd44031f8c5377dbce6dc47be4779b31b7c9bd3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62fce098ffae81cd06f594052c62d2e02bd7f62d246294418f8b30037f66679b"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/240464d54ac498281592eb0b30c871dc3c7ce09b.tar.gz"
    sha256 "79fe6b28b056a1fff41123dcbbec5cad67382cc83c8f67484c4ba37192b8dceb"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
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
