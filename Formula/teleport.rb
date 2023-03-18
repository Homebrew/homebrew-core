class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v12.1.1.tar.gz"
  sha256 "a32675061315fb688a68452d5d0093e2c8cef67fdef292057537506d3b22a126"
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
    sha256 cellar: :any,                 arm64_ventura:  "911085bf5e4c8cec018b2786ee9366d7ce194767385888776c167e48e2c6f79f"
    sha256 cellar: :any,                 arm64_monterey: "815d18e3cad1c472529394657c2ff50ad475fd8c8957d9f4819f6f693001a316"
    sha256 cellar: :any,                 arm64_big_sur:  "05c9e760427d76877e8628b2a073e2cf0609514a06971a9f54dd1850f1f54cd7"
    sha256 cellar: :any,                 ventura:        "fa5667cd153214526a1a3fffb2e45c38c2f745340c2955a062ef7c23aa633909"
    sha256 cellar: :any,                 monterey:       "946c44cb4bbf0635e070a50776b8d810f6f5e9f389bfc81393a87ce7ff664d8c"
    sha256 cellar: :any,                 big_sur:        "0367a4d87b3db54f8547c2a07fc47ffca27717613e3806340072eb70f8eeebf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ee94f2f7a5b4f6a0284c4c1433f71c79f986447841dc4affed38683aeacf3f5"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"

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
