class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v12.0.4.tar.gz"
  sha256 "138322c8fbe92be8a6d3094884923ae4268d5aceef3fbac5875b60c5528b06ab"
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
    sha256 cellar: :any,                 arm64_ventura:  "9875b90921970e665cf5bcb3100c1f212de20ebeead858753d6a3d093dfc59c8"
    sha256 cellar: :any,                 arm64_monterey: "3718abec7cfecb6086e2a64f466734b870c38fcc7465778282b50957b7909afd"
    sha256 cellar: :any,                 arm64_big_sur:  "a64e19b36be1df44278a3f1465ab7478d276235023b9990c673c700122500f07"
    sha256 cellar: :any,                 ventura:        "2005153b3347c8d777c04debd70d8f1baff71a16542bbd69c8e45a2f4633d1ba"
    sha256 cellar: :any,                 monterey:       "fe0bdbb09e6b2b569f9ac1d1494082a281e8e6f2d645b8c33a112106d515369d"
    sha256 cellar: :any,                 big_sur:        "d54e1a3b7f44699116ee07a151f37fcbc3b35d94a531ea67d5ecabfcb363cb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c42a602bc27c41d062aa3ae65684e315616acb8cb4d131ac25408ec4efb79fc"
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
