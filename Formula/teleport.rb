class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.1.5.tar.gz"
  sha256 "25195488a44a53ad1e2ecb552900631c176ac4449d0deaf823ada96513d6e864"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7ee683f7c7c1fc972d080227bcf550c00ae8c939a8e6a84e0eb093e0e7f43e1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a11e8aea97f106ad17fdea47a5ce43be358b679b8641ba65db1d629506309602"
    sha256 cellar: :any_skip_relocation, catalina:      "f53ce64bc51fa82710e7087409b3a2df4a49fa9023e9b555fb267a7bbbc874f8"
    sha256 cellar: :any_skip_relocation, mojave:        "028fe7f7dba009865056f3001c63ef6afd9ced763fc23dedf3aba881830be983"
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
