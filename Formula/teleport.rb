class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v13.1.0.tar.gz"
  sha256 "2cbc15d2e4032bb40a32a6b586c6fabe2d06fe5f7d4024d1a9135b2037183b5e"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a0387fb80ace5145e04c563dc48a1ffc6e7e59fc7214b71473982e9758594ac"
    sha256 cellar: :any,                 arm64_monterey: "6c1a7258c41648c16926eb89dacc4c30736e88636febeb12c6a6203cd034e358"
    sha256 cellar: :any,                 arm64_big_sur:  "76b45240b5725094eea724c9c9b4076e96d6d3c9d6f5cb06ac907c18c41fedce"
    sha256 cellar: :any,                 ventura:        "05f6d60a579d88c51ac4cf0194202b27ccd0d702daa34318c6355ba1b1b86d23"
    sha256 cellar: :any,                 monterey:       "77a78c89b52f513805fecf1c9b92178cb92c85c373f7f2e67ee9da7e9c66660a"
    sha256 cellar: :any,                 big_sur:        "c5b8d070078c37b229c5090809065c7bd36dd95b95f77a97f11eb10b8610ad06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbbbf85b851c1c5f8de27ecf47576442680dd3810e522975e383cc7fceb2819d"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
