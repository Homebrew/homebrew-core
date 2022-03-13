class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.22.1",
      revision: "c8fb4f8c79259ae22e4ddeca2e6f72a832e07a47"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b178d860da9d38e35149fd204598c119a7844c516077d93b3052e754561f8838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22e58ef06b671bab3fd9218e68b74eac5eaa577bb369816c5ec337b285533892"
    sha256 cellar: :any_skip_relocation, monterey:       "b0e83f33b3e85be5a7de75b5ccd69a4c02c1c39aeaa195ac8110eee8240d5aa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "61b28ce9e8d21b8eb5b69de9a4edf7d65854e97346ab4e0884d4e3012cafa2f0"
    sha256 cellar: :any_skip_relocation, catalina:       "b0369f1114277d5a596dc5a6a1d85c7172bb3dbb043de06eb1f0b3e33c479978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc65f5fd5187ff76e33e37ff3a139d71330f1d3220d4bfdff220080ed79ce9c"
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
