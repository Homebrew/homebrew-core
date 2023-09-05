class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v13.3.7.tar.gz"
  sha256 "17e7edee92164c2bb6feaef6ba74428b7b5297acd962887d6c953ed2b993b5f6"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbb6034b274e1c095b5d35f360c9ce64c9d99949ee8a11cd949c2aa349b85fee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24de20e357f9d30764e1bea0649c20c0fb24f532cdd07d8e6d764afa57880b35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9caac49b876ce12d7ab465f7bbf059a34eb89ab1809127005d8f5ef51305212"
    sha256 cellar: :any_skip_relocation, ventura:        "2b3e5774fd163aa38f8d8e26c7e79bc115b27ca5ecbd3f2abb66a577d55e05c5"
    sha256 cellar: :any_skip_relocation, monterey:       "54d3c84878bee1a9c11556de0007893b18f4c5282de72bd9ea7fc8b6775ab505"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a81d56a957cc9b74070c1169eb13ff0cb44255393e55744ff2294db582366ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b55828cb03e099a72287f0b1dda41e9e495db85af26e8ea04c934beacdf5b205"
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
