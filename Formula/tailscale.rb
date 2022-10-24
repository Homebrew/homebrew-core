class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.32.1",
      revision: "f8497daa68ef312f87c6583c41c9975500d5b88e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48dd9e20435c08920b7e50187b625a9d13392392ac8161b3f4ce43d833700c09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e1fc6457d53ffa00e7c43e4f8ac38659d107826723bba597ce80d0219d6442c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c8871b26b480685bcf47c1e835636870a3020fe41d21e2b070a4361e8413c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "61d35e7282f6e9cfd8539b1366da677e83a31fef2922bd876ad8ec3bf8eb175d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaa8cfa67d216070659e0db9aaf4bff12193c4c638eb925e51705c7100f350d8"
    sha256 cellar: :any_skip_relocation, catalina:       "fdc8ced94ecd27e43791217fcecb2a2c40f4a2515483917c08fd1fe938f13eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57295ee5475f85720a6d0902f4701de40887dbf4961142d883ed677237b504d8"
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
