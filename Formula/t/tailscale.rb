class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.50.0",
      revision: "a30a7198bee21c331ab9e561fcc4e3ceb88f7044"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "298b5f4d32bc10c70f28f875693fa98290e7710fda33cb618d9bbf74d848f916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74b1e07b6b6fae6f270fb9b5955781382df62ffc6eb39ab087feac6a9fd40ca2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad7e446b98eb06e723e54628f4acd54ece87311f8bdd1ae61f6e016879ec067a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e14885a5258409b2e7618389529103cf47934f170d2162a179119e18440bd9b9"
    sha256 cellar: :any_skip_relocation, ventura:        "1b755817fe676ecf8140fdf1ccd2d2b3d166b6770bf21e3f85c658e69a672366"
    sha256 cellar: :any_skip_relocation, monterey:       "38138ccdeab88307993d3105685bbf451a6aad9f923daacfb784a22e18d40b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30623cf0ce63a61247dd8ac398ad785f6ad83162c008b0c79eb4b12eb27e1040"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"tailscaled"), "./cmd/tailscaled"
  end

  service do
    run opt_bin/"tailscaled"
    keep_alive true
    log_path var/"log/tailscaled.log"
    error_log_path var/"log/tailscaled.log"
  end

  test do
    version_text = shell_output("#{bin}/tailscale version")
    assert_match version.to_s, version_text
    assert_match(/commit: [a-f0-9]{40}/, version_text)

    fork do
      system bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    end

    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
