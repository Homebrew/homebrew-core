class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.2.5.tar.gz"
  sha256 "08d8b931cee7e1b0ef676894fcd30ac057f7eda18cee9e73eddb695c3a5d9108"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "13cda735913becefa9a0e05c0c8017313954d4c72af2bb5670b5fe134a34d872"
    sha256 cellar: :any_skip_relocation, big_sur:       "05c25399675aed895f71a1cb07bb6758b6734f8ac415d0fd5c3495a9e3730daf"
    sha256 cellar: :any_skip_relocation, catalina:      "1b5c243fbbb5f268a5e2ddfcf106323ad5e9cb256af0429c046b1cb8bc826d70"
    sha256 cellar: :any_skip_relocation, mojave:        "efd6af5ca8bce9a1d4574aa0f4f28eb1719af45582ecbd9f616d012522893d45"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/8a30ee4e3570c7db0566028b6b562167aa40f646.tar.gz"
    sha256 "54eedd358523526945d309f16b5c53787bc7a9a9337336661361385a6767fc42"
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
