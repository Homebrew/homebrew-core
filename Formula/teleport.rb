class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.1.2.tar.gz"
  sha256 "b903c4a40f894e8428b56a00b2867867b2470398f17d46eec1a8da992b28899f"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2a75b8f4eacec9ec30a833202a1f2653e687688743ad8b0d0696ea6c4ddcbb6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "94dbb8255bc7ea3ca292d11c849fa85c56dd95169c07548b724d1d9c8dc00d91"
    sha256 cellar: :any_skip_relocation, catalina:      "0115ce9285d1caf52c1b5d2186cc1d605bae21f0d5e3e50fb0db8c4b5b0023cd"
    sha256 cellar: :any_skip_relocation, mojave:        "f86ee7eae04866f3adaaffb3c80b1220ef88004970f3d80c93a602a3092be517"
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
