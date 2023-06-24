class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v13.1.3.tar.gz"
  sha256 "f1ebae40450020328b476efae7e4876e809293ec25a31ee89c449591a2346821"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84c9d80020182158714fcce5c08df6d8136b4c70cdbe2da925b2b9205fbb2e69"
    sha256 cellar: :any,                 arm64_monterey: "e4b598524e91869526f0d3cc5131ad3180ee64175944e955902730a5b716565e"
    sha256 cellar: :any,                 arm64_big_sur:  "b191c1563aa5ed39602258e7db97545e5ec150a808527fcff11bdbce7704e294"
    sha256 cellar: :any,                 ventura:        "ff906e83440c780b0ae05a21c99c960976e40175d5df3975193edec06266babf"
    sha256 cellar: :any,                 monterey:       "ab277935cffae9364d14656d59818e1b89eec1082ced25691eceb4492577baad"
    sha256 cellar: :any,                 big_sur:        "f474aca4c258aa2bcd7dee3a0a68c60f862a53db6bcf0ec786b453e1264f7ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4e756db8d7b8d66bdfc9b15f79e930f587872d42e392f2d27481963110b95f7"
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
