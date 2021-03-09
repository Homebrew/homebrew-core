class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.0.1.tar.gz"
  sha256 "2cfd723902ecd60cad079e6f8a72ad73739b8d3c755019aaab69c387bf7feeab"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "faca3c70b1157c916bd519060e362fda1283a52b587c2f18416651c28806118e"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb076944ee212726ae9272b09d2f0cba0dcda8c2ffc0dbf09ade8c07d3b7c2b5"
    sha256 cellar: :any_skip_relocation, catalina:      "c1ab38f830f0f616a1b3af15effb154e69ef81bff4b28387beedace052dde93f"
    sha256 cellar: :any_skip_relocation, mojave:        "48f7b61ecc4146b3a44744a8097ba9efc8a6675ed6ab9a3e35e01e961ddefabb"
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
