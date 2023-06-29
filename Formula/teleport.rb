class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v13.1.5.tar.gz"
  sha256 "e423a61d4a379ecbbb721e5b526470818d8652c2f1cbba25a026829de3884099"
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
    sha256 cellar: :any,                 arm64_ventura:  "a200bba53a3ca559bffa2d402510fb76eab2772b864656916500da26340a79e7"
    sha256 cellar: :any,                 arm64_monterey: "d673d9cf6a03427196576831bdab2700573b7c06085e07c73407d2700226a509"
    sha256 cellar: :any,                 arm64_big_sur:  "ded009de4e787bc30d2ba980eaa4c776f9f77d33133c4d15382d93d4fe1cb50c"
    sha256 cellar: :any,                 ventura:        "5d63fc8291b480572e3e220b3e272ac01a6a6c0d7722bf4a6a2e2e7151914d33"
    sha256 cellar: :any,                 monterey:       "0d7d5457b125873bd37de3e205390b5fa47837931c6e32c55a3e157b046b4b09"
    sha256 cellar: :any,                 big_sur:        "8e0acca283857a0f3b59add0488329f433ff8cb3cdbcf55d5ac44ff04de37f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c169fbb748b22b5c1a56ce227ff94da941498901cf0e713d473c70307daaa8"
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
