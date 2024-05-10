class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.66.1",
      revision: "88e23b6cfd4b9a9cad5ce858b73ece1f07970fee"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d92cfb6a04a871a3728526f4e3cc540dc8c3539194a1be920fcf6f664ab987f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b1a44f31a6fd7490774d9dfca3d697a64c81ec02c38c7724fb2d66983d22989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "361017e416878872073477a1ff519857af6152f20e11aa77e1ead30e97ab72e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c49b0fd11045ee649dc7d68641cbf1bc6a34eca28e17b5057b5101716e74d061"
    sha256 cellar: :any_skip_relocation, ventura:        "d35845c7148c3fa87b43c6e1a28191e51af0845034af6a09c364fe1ef72cf889"
    sha256 cellar: :any_skip_relocation, monterey:       "a753a48648103ff3162ba71a2feda8fce28e0e80884e4eb7e70a450c89076a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1ef3cb9b3b8de2c2711bc4ac2ff38b6aa5eded320bc392b0ce7595a471ebd50"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"
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
