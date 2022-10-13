class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.32.0",
      revision: "fc688fe02496cacf919f9fed2069ea41a8b87500"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b49b8d5c2c9fd61942d20bf3c4ba1154ba9e987ea0cef4832749d985ae0e8650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f185276b717b00bf623e1f663371aca88b4bf0d83e4c9cf268b7c512b8575a4"
    sha256 cellar: :any_skip_relocation, monterey:       "e75801fefbee372c4f8e30dc0c5378325e438dccd8c9048815e57d2786332962"
    sha256 cellar: :any_skip_relocation, big_sur:        "28cf48120785eddd638e704208aa658d15ee6b849def6ee4cd5c89db9f4b9022"
    sha256 cellar: :any_skip_relocation, catalina:       "9d3b26cfd3fac37951943c19cb88ccf4c0237c9c8b445d2e13bf4122a493e546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf6b0c503bcf441aea55535c2a8daa0bb1e8b0c39709534009d8a02bc0ffb96b"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.Long=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.Short=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.GitCommit=#{vars.match(/VERSION_GIT_HASH="(.*)-dirty"/)[1]}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "tailscale.com/cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tailscaled", "tailscale.com/cmd/tailscaled"
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
