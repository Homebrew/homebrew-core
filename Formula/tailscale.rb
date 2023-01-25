class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.36.0",
      revision: "ab998de9899da026e1a623a5973143f0d3ea52f7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1fb3cbfeedbda2c44ad5684460d2c11df7460381dc6dbf423f1d388089ce1ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f69badcfe0553ad9c9e44b09394a73ba4cf12edb58d68ba0150327c7b9dd6ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "475d419235a1c86ed73b0db960656f8858618d4e9eea99e729f76a6e8e41ff4e"
    sha256 cellar: :any_skip_relocation, ventura:        "af50d3091fdc7641bab1f249dc6d19f5bd40565465759276eefb46b2b39c4bfb"
    sha256 cellar: :any_skip_relocation, monterey:       "8e407b85e73a9c4182539a46707c3249b58b38ecf1c8c80e88cc82a4235e0c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "c43690019f4264d24f41c025f0592bc006f164d978a1ce6c59467178d95c5b75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2835091b22c907425cdf4a7d568a6c9fa73d5fd75d59b19e7c30efe80345505"
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
