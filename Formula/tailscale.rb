class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.26.2",
      revision: "5a60f1ffe3741c55eb9637ddd2f20157d164f511"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "518b0f82ec8d435e468e1c68d1395893002a9b4d52382733ce7a351a72bb8b36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6b7ef10b516ebb9c810cd3c673d6e9a112127c0a0c8f1eac6fda4118f5fa8ed"
    sha256 cellar: :any_skip_relocation, monterey:       "f32ef64029fddcb5e6589ed5639dc81f26363fcbdd06ee2876b242bfaa170fca"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef0c75f20b897e7d8887d28375e43286c191cc21169f66635ffcc3353065ea0a"
    sha256 cellar: :any_skip_relocation, catalina:       "7bc441f49b2ed6d6707565e69b96551bdcfbae51fc2e9d011327e608692cf3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2442c64c79caf7f3b06d15f708d6efc54b24f797fc50358e69664a6eece9d0f9"
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
