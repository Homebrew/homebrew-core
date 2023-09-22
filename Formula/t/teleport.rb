class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "691ffb331f33376481d8baa019613bca9962be28400fe8909241201f8df02d7c"
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
    sha256 cellar: :any,                 arm64_ventura:  "1791d324ccd79be54cb05f877a11ade0b8016be1bce718be7d9f2b484d3d182e"
    sha256 cellar: :any,                 arm64_monterey: "4b1d9ac7f81131fbebdb7e66b064eaea6053ca3ad3179af3d4752f78df929bac"
    sha256 cellar: :any,                 arm64_big_sur:  "72b1a2edc7af24af468e08059590bb84991646b8465de8a69d67b07523b31781"
    sha256 cellar: :any,                 ventura:        "c4139e5bc52e8d8d00358b838a7e8cb572ee012d417a0466b630adf56d6a3456"
    sha256 cellar: :any,                 monterey:       "32cc58b6af8dabcb96d97c2afdf38a7ec21defc1d5e0b676d453b9b34f4b5607"
    sha256 cellar: :any,                 big_sur:        "701956794741641dd2add422d1abdae8a37c0531ca8bdd1590bed35b08253a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df713810144b79f0fbcdf4ae108565afc14f66bef5535fbd1f8dd7c4f3e417ca"
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
