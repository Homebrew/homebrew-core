class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.30.2",
      revision: "11854574919300b470a9cdda4cafea7d1dd66b11"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "152f30558b32dc268136e10d7bf26baf5ca31da9a3cd2ab497d2c6304d874581"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a02c5e811240c8bcc54dfc2c012d1b8514fd48239cb9a737cf3b8f47039c535"
    sha256 cellar: :any_skip_relocation, monterey:       "c57bb6d1d3a49075a48795e7ea871c4a4eb853ba8aa72f0d2070661a8925b44d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f124615699a9cd35de61122586fbc714d027ee59b442824fc65844bb07e4aea"
    sha256 cellar: :any_skip_relocation, catalina:       "4e72b440580adabae3fcc6e082e3812cc54d8601e21ec321abccee83698ebca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6ed12b5ac26cbf76d16f36415cc2966f304ea0a162297c7805578a65a1ee2a"
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
