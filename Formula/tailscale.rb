class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.32.0",
      revision: "fc688fe02496cacf919f9fed2069ea41a8b87500"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c84179855189c07cfd97bdaacbc15e138792fdb9cf21b5e3b90e507657fa2109"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "928bd229832fec9f08afae5fedce8956a88436de44628a54514700719e81f13c"
    sha256 cellar: :any_skip_relocation, monterey:       "f2cbcfede0d5496279ed92101a4a0499203895478ea8b71afc18d6fd7a41163e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b55e4f00ddf0a182d3da2a3b41a4fd54a212f465ae628fcf78cad3ce3057c4f"
    sha256 cellar: :any_skip_relocation, catalina:       "37028eb48d45de96a6a33f0d4e1a7181d09baddfb7fe4780ccf81e504500a517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c24051d9f381f598981c3039e7130321e3fa8b5a223e211dad6794ec12d01b8"
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
