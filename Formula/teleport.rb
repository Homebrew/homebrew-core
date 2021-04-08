class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.0.3.tar.gz"
  sha256 "23a61fd842a9b5faed8d0deed0df0dbad25afc703fd1fbcb5d6216e9e90e95b4"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20eb6146838570598b1bad382fb75e56b89353f7cf8cba589bfa9c7a5958fc40"
    sha256 cellar: :any_skip_relocation, big_sur:       "39133e6fd1b26fa2a323e8d37773fc9e326d7edf18be464b940282823c1796b6"
    sha256 cellar: :any_skip_relocation, catalina:      "debf82dcca523d44838259249b15c44028601e541fe81e11112ad7bbc0600509"
    sha256 cellar: :any_skip_relocation, mojave:        "ded37349f54eab2713245219a1df765791ad208e4a2981a75eac5323b250e971"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/228008d85ec49ed98385324bb4b5eb98bcad8bd7.tar.gz"
    sha256 "3269e7519c617dea2ca7b776cb74ee16344e4b80671e4baf4c8213691d914f99"
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
