class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.1.1.tar.gz"
  sha256 "4218198595398e4f04aa53c6afeb29636972c88971aa652dcb85aa8863030c9f"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d90f1325e02b5297be13525f3bda1405448e99d732efcb63c362769f10a13f8c"
    sha256 cellar: :any_skip_relocation, big_sur:       "42f04894e8a1abbdde5704d6ef2194249915e5233d6ba21c574a4ed993dfeed3"
    sha256 cellar: :any_skip_relocation, catalina:      "47f0d244281e24879b7c5526c28c80c151bc72ea980de8883c1957531b2bf41d"
    sha256 cellar: :any_skip_relocation, mojave:        "e97f5e5885742a031e52ec73869332b5267df3c8bd29070a78c8a54567958516"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/c0d1f3ebcf5bb213fa0f7753d9e69005366f8431.tar.gz"
    sha256 "d030671553fed0e564eb582f65982e0af4bc75fcecf3b2b03d210569c5b6d66d"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    begin
      pid = spawn("#{bin}/teleport start -c #{testpath}/config.yml")
      sleep 5
      system "/usr/bin/curl", "--insecure", "https://localhost:3080"
      system "/usr/bin/nc", "-z", "localhost", "3022"
      system "/usr/bin/nc", "-z", "localhost", "3023"
      system "/usr/bin/nc", "-z", "localhost", "3025"
    ensure
      Process.kill(9, pid)
    end
  end
end
