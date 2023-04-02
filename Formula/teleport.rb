class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v12.0.5.tar.gz"
  sha256 "bff91988b96503732d061cc86800c38d9315650c4177d1387e302635ec1d05de"
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
    sha256 cellar: :any,                 arm64_ventura:  "434240984562c8947998a294ce4e537084f9628d54903bc8c66be5076e02ad48"
    sha256 cellar: :any,                 arm64_monterey: "12d22bf115e62bd842f5226442dbc43021c1e2b08f411efbbe526e2fd2b0d4e7"
    sha256 cellar: :any,                 arm64_big_sur:  "52c04744b43df70e6f0faa22eeb76dc05c0141ec6628cfcd887bbf2f5790e003"
    sha256 cellar: :any,                 ventura:        "f5bfbde70823b8f59e7552c7e80f5b55fc146b18e7ae488422945feafd8db0bb"
    sha256 cellar: :any,                 monterey:       "31e76f4c212228695e743d4010d744e06732328eda2e25ede741a5e574537b7b"
    sha256 cellar: :any,                 big_sur:        "37d9ffb895349ef3e195c296367183374cc6a4427f4479806068976d5a89138f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc8b780e85eb9cefff37e397d9106fff1aa2da5c9702db0571644582d2fac43e"
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
