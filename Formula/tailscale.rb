class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.36.2",
      revision: "0438c67e2517c78feeaf0d9f61ea2a6303dd875c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a2476ad744b07f38718c06f734f84709ffe663fe3c34d0f0afb8c003b9dc980"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6f7418c54225579fde65f26ce4302480291c2444c9407a43168b889b2433a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54e1c76b924df28fa2d423e5ec6a9c7e810420005c4a35fab6f3c440653f4948"
    sha256 cellar: :any_skip_relocation, ventura:        "5fc43586839dc91a7ab2cf8555e218e22a6e454b1f72650038a86a558e7ca818"
    sha256 cellar: :any_skip_relocation, monterey:       "367b9dbacf0d7e00ec7bc532f0477816997e7c8a97e82f064be9fb2b50d37cd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0ba4eca00f07d270cd80e13ba8a4d20e3fc08e2356b4d76ea690decbad9adb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008fa2f3e98267c417b3ac75ab523c0d46d5813a6f39acedde76e32664987bbd"
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
