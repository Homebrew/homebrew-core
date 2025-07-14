class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.84.2",
      revision: "5f702f4c2babf95e4244ce0dafbb7a50b52c1fc8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9160e50845fa2b6bfe1ad6d33be4349ab1dae1b632cc962e1cf4a8128abc68a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3558192ebdb84c37f3bdd6e08f629dafbeeb03d38f04baa1fe788fe7fa2ea6bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c65e0420dce23b74e6fb00263f5997bbdbf9e4221aa359d53661793b8611a758"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b465add3482295922e12702955f16919f3a3c16dcdd7a774214dbbc058a7f45"
    sha256 cellar: :any_skip_relocation, ventura:       "903319b68a8a065f1e1beb2b39a7817e216b67216f6deeb1a028a02313b526ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e4fd4101b52ce2a5fd6a59b06e181910d6fbac5412e7327d691214f40488db"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale"

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", "completion")
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
