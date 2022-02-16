class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.20.4",
      revision: "8e32002cf32c03682a5156f2f9020b088a5dde7f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "730314647b2a17db7d7fe1df6c21b4a53d17769a47dbe23da3b6b64a23b9b666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c6aec47c96f185f3506d3553860406176bddf906c51975c5b0216fdd48d7df5"
    sha256 cellar: :any_skip_relocation, monterey:       "b5242bc3721001759c0aec46e064e164be90eb733d5c784ba88d277e11885e56"
    sha256 cellar: :any_skip_relocation, big_sur:        "87c2d2d0e5b3cee8dbd170c75db22670bd93112aa32edec48475478199d99db8"
    sha256 cellar: :any_skip_relocation, catalina:       "37b4880019b07715a5c5c8c91f4e52570570e3d50f8404198916967f3304e54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d05d5763d869838c1a6a493a1844ff4f01dbda16d20deb08961c100c1d554fcb"
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
