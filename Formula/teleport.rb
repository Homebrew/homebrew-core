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
    sha256 cellar: :any,                 arm64_ventura:  "65f90a3760edb9fb10389d5a9019c94fcc480ee17d66dc2e6a076c4c08a09af6"
    sha256 cellar: :any,                 arm64_monterey: "3e24db9715600622db8040623cf480a3d27bcd6eccc9890b9e3ec1064baf537e"
    sha256 cellar: :any,                 arm64_big_sur:  "ac9c697f509774ef5a9e661187b5f092dff6d708259b33509b9166ff6fcaf3e1"
    sha256 cellar: :any,                 ventura:        "d3bf5cb44be139a47e0d109217df779ac698734f5c3b72a0e8b16d170d0c7161"
    sha256 cellar: :any,                 monterey:       "9b3357a727dfb0f53d12ed345ca8563d10614a2cd2862ac763ff9562c97b1359"
    sha256 cellar: :any,                 big_sur:        "aef12685e84b613d74a5376978c4bad239f805101236b43016669d5a3bffef80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b1b0d73180686361ba354bc3a21ec30ce75540bfc2e2a1ad1ff4a267744ef0"
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
