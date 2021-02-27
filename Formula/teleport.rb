class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v5.2.1.tar.gz"
  sha256 "4f03f1da266d0904a9e7c41a022ea4a2a03b7d2a7bd7bf3759e83ef23f8d86b3"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d297ac059f06b0f1c6087cdf8f0d7ad35566bcbf4344a4f707c9de68ee435a1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5449dd0e13c91857979475f18c1b19c7c13cfd44cdf8c112d474ef732dc3a77a"
    sha256 cellar: :any_skip_relocation, catalina:      "7cb26e9d367302c80202e560fb932438a38e1541d1519a18ca4542cb11b29715"
    sha256 cellar: :any_skip_relocation, mojave:        "12ce513bfead1a75d22433748e713376302afa8aeb92fa098ac6c62d207a60e6"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/8ace0cfcc6867651bed3fd5b5f35aaa2a80e1106.tar.gz"
    sha256 "4af3c005d0ddc0215b621aa4bf13655dd7e7266cffced2cc7f64122e79c0949e"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"webassets").install resource("webassets")
    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
    end
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
