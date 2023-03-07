class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v12.1.0.tar.gz"
  sha256 "b19708b41898050557e967362674d6625a9066fac6b5fad3744209cc9b3ad518"
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
    sha256 cellar: :any,                 arm64_ventura:  "785564d5e02ff6a4f560c5a840b9aae5281bb6c9cea490beedce7c45b92daa38"
    sha256 cellar: :any,                 arm64_monterey: "dda66b26a555101d07f278f5a37f75fc4d01636e3c093cdce2d1d1effbd97f2e"
    sha256 cellar: :any,                 arm64_big_sur:  "a6a1cf9e7369480359190c8905829d3341ad326ccc857bf81a4d2d56596c1166"
    sha256 cellar: :any,                 ventura:        "9e945237d5d6a24074c3034cdec1fca221fbaba66b6ceabff0b4c05f3993075d"
    sha256 cellar: :any,                 monterey:       "75ea15f1daf30f410bfbb1d0f9355df8d952e72980f597a6190605b0218da4bc"
    sha256 cellar: :any,                 big_sur:        "5a38eba19f3e6c69625e1a16932f26f9bc27763d06a29d1e141accd979b84bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1279b1b3017a36e1bb4178bcb50f369b27095363fe2871b96f9a812559b6e58"
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
