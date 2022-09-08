class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.30.1",
      revision: "949c4003021d533aefd3594623675550d355015e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f32a25536390eb7c5358d4fffd1c238f5dac26e334374bf3a4c10443347f736"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfb27f8fde7f92ef557ddf42325bf0561e2cd3bd95e7e09fbff43f79cd7c42f"
    sha256 cellar: :any_skip_relocation, monterey:       "ad96de60b24a239a44c7a0b7bcbc7f9155ea62fb11b966bd5667f66c49bd7adc"
    sha256 cellar: :any_skip_relocation, big_sur:        "502192ec47c46ea60c4a3bc67e16e5593bb215074a3b57ac07dd8b9bff0a139b"
    sha256 cellar: :any_skip_relocation, catalina:       "d4b1e1d63ae1e25dfd0034e781a5b0d8a8621be165fa4a9d9fb7724a4317fb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087c07aa89d55808098d1d83ed1d96a24861492bc42a87116bfc16cd30bd8e4b"
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
