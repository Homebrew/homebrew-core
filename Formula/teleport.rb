class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.2.1.tar.gz"
  sha256 "cbbb11e74e1641a1716af4ff815f75f8794ca2b39690c9fb2dcce003646318de"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d8d466ad3c43a683c06eed2e9ecd3370afd66feb284665ba9d9c1f29a599258"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c3561e5cb4c4ef70a137cc6f13198c199e266917ab0f624835e3adb0beaaef4"
    sha256 cellar: :any_skip_relocation, catalina:      "e195317c5b1c71f4249281957b12330a34e466644daee438914ff24b76a5b0d5"
    sha256 cellar: :any_skip_relocation, mojave:        "2327f89790a26ab5c586727c4610ca254c0ec87ac905bcd6327408de8b8a33e7"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/8c2812c169fa6bd5f31c13160bd93ef8b317bbc9.tar.gz"
    sha256 "14445b0864d759347c1f53dc144a346b1974b8ded49031d7f0b7227f5d49d407"
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
