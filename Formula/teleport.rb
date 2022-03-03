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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b612db6e516aaeec330d3c14d2c13c01ddbf40e8f5d1bb6b2c2b5e92c3cb5208"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "963f5ca961d17de409fe1247984714f3be36c3eacd81eae94097eb225e6186f4"
    sha256 cellar: :any_skip_relocation, monterey:       "5b42430c5ceecca543c10cf3c79d553ee96bece5e4f0af8b476521d325865759"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a91d286c68399974727c2a157418717b0dffaa4f9c93ea6ae8eed096cc03a4d"
    sha256 cellar: :any_skip_relocation, catalina:       "c252c66e03004cf2864a0c1b413ebdb36cdf15b29531f7887b921ef2de9bcdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83fee78f28034b79bd6d18ebe86380f7e7535052e34514796299d3e17ffc745"
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
