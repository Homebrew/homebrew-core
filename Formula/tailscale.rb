class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.42.0",
      revision: "ab797f0abd067750d474668ed615d7dc9d258cec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec2c919ba6f9e1a0cd0576dd98ce3ec3415a1426f49e127cf47d177722f14c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec2c919ba6f9e1a0cd0576dd98ce3ec3415a1426f49e127cf47d177722f14c7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec2c919ba6f9e1a0cd0576dd98ce3ec3415a1426f49e127cf47d177722f14c7e"
    sha256 cellar: :any_skip_relocation, ventura:        "86a65b0d20e19089cb949f57424742e2947edaf10567d928eee0d0f39021eb36"
    sha256 cellar: :any_skip_relocation, monterey:       "86a65b0d20e19089cb949f57424742e2947edaf10567d928eee0d0f39021eb36"
    sha256 cellar: :any_skip_relocation, big_sur:        "86a65b0d20e19089cb949f57424742e2947edaf10567d928eee0d0f39021eb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b9ec27fdc8eb07a4ca0ddc75d83cb10ec0895014d623444d167a52a7e79462a"
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
