class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v14.0.3.tar.gz"
  sha256 "37768a022fa478c496236286d576489f6814688433be41ddde539774d3b2bca1"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd5951cc8128d2ec5f4034dc5e0c55398998a23e0a2a2d9975b1107cfebcd325"
    sha256 cellar: :any,                 arm64_ventura:  "ff5d8a4863d9eac1e83853180a0237e10fef0c35cd2dcf608321a090622e5d5e"
    sha256 cellar: :any,                 arm64_monterey: "e5d3f7be0fe862310b870086ee86fdb94e10fbd9c71b2bc59f5d91a711852170"
    sha256 cellar: :any,                 sonoma:         "ed216ccfa10a5dcd804f9fda84b5624c7edea16840d5ebfb1261dd18f5cdee4d"
    sha256 cellar: :any,                 ventura:        "d586324a94b2c9e0b92d6d8870ab9a7c5c3578c8d33032f308190f30a99bd8c0"
    sha256 cellar: :any,                 monterey:       "9632d5c573bec2a629bd0bf210aec5792e37f0aa879a7764cde3299f631d36d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6baa11096c692f31e227c17ea433492fed872fbac3a6a4f0fdd2826b4109867"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
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
