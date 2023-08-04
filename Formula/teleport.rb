class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v13.3.1.tar.gz"
  sha256 "93d993e63981da1146b9045b2dcc05239db4b08cfaf2faa31eb15110d2bef5aa"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2d2f9d787d8aa05a8f54138d2d0abc244588e03cf551133e6ee9f23e40db0ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e1d8d2663320c95512217a93d87dd0d5735da7dec57b0dad6290138fa4b52a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9f74cab77080880c488e96a0f0ad692fa252a54b1c48ff2b6584b28642260f4"
    sha256 cellar: :any_skip_relocation, ventura:        "d8d686773c5feb55b627d71a804182b5c5784c4a2988a84bcf1dd0f6c9a8166c"
    sha256 cellar: :any_skip_relocation, monterey:       "31013f9411886f2748469b0d2d0a4c1e8eefc4720dcf8d2392617f39e5add427"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e600729d92ab0b73f9da908efe0415286c66a9b5deeb171f1fcebe38bc92e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0461dbe46284502ea8a56fd8abfc2e5b601edc2ff9e3c0994517cf407b0536"
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
