class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v6.1.3.tar.gz"
  sha256 "b92bf2168058ac757bb396411c6b93192269e206fdf4eec13b17140f2a3dd48b"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b705c684a0590d7d106467ed02d7f27073817f842429b2ece1f27a0f67af278b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3c69f4045bed238280eeab63cc227dda0c72a8bfa71c10c63951282c822b2a4"
    sha256 cellar: :any_skip_relocation, catalina:      "7ed4e67a31c68f9ed94b55bdd1de3c206a1a7259dbc883b9dfb3c052b3cd3323"
    sha256 cellar: :any_skip_relocation, mojave:        "56a59bfb503fcc23e36bc65af15f314e6cb7636b4860d83070d29d0fba6b3cb8"
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
