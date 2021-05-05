class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.1.4.tar.gz"
  sha256 "c552be9ba8b8c7548455e33254157a5563b4748975895743f837985cdb553bce"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c21ed65d9a09aed14c99e10d622584b4039b6cb7515bb965b0673989c7e7ba4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "afb6d624f92e917418d19f9c87e96bd80fe04a408bbc327fb2f71991e1ca3923"
    sha256 cellar: :any_skip_relocation, catalina:      "b90e9e5092ee99dd71fd90c211c63567400bcb67d2289502b2c568cfe587d3fa"
    sha256 cellar: :any_skip_relocation, mojave:        "5b92659e75fe147f502b7f7d912e13a008aa1805e87e18193ba1babfa49f0861"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/4cbcbf0f64163daac80d176e05e861ae1e05bc6c.tar.gz"
    sha256 "d8a0e93d984c12e429f2a036530ed359f82f4111e648e0b74aea811c6921f69b"
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
