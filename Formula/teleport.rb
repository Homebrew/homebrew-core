class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v13.0.4.tar.gz"
  sha256 "6b30ed176b1b5b2e26d5b5cfbe451b88bf030a827190bdead3698da3a1816d83"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" tag can point to a release from the older major version.
  livecheck do
    url :stable
    strategy :github_release
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a3b48b6f61a0c0e03d97968c0568a4a7679b094cf478da96f2c70b442a6a58e"
    sha256 cellar: :any,                 arm64_monterey: "b0bfb6f82de976485534c03b519fbcd39d81e18ab3878d20865bd895418549bd"
    sha256 cellar: :any,                 arm64_big_sur:  "b80e8c5a0439726923ac46dbc16eb6f17e914c27ac95d406f9b499fcdd6de65f"
    sha256 cellar: :any,                 ventura:        "8d96cbbf17bdf00c9c43d8d05f70809274c43778627d72163326012bc60d772b"
    sha256 cellar: :any,                 monterey:       "911ec14504e00e5933e35000e7d26dced4ba741bf50299b6175c992df34553f5"
    sha256 cellar: :any,                 big_sur:        "8170f3de3b8f00dea74ab9fde9f4feaf76dc13a2f73091f5210610ca0e88e6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd21d5dcbbec956f428b1b67b147e5ae65c913310a00ed5f3fb5774320ea766"
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
