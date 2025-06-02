class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.84.0",
      revision: "0b36774ff9e8d5a82efee38e3734298ffb453ae9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50e1c5b8be7dfd006beeb57b6a7fc4de165f356f31615d28d9576f6d3c19e659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03fefd0ca148819ad0d2eb6206d8ba27dbb282dde43924af6fa45622c15f194f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ff1a99b0f752a1a7825e039b0b75648ed0b119d2b2e4b5d22c4379e4b2daba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79a7dbee0fcea656a8cff98c9327fc6c4c265069677588efd19a6925be1bfdc"
    sha256 cellar: :any_skip_relocation, ventura:       "88437540fd67689b6281483ea21b9bc42db10432e77f6db7d3ef5f8f518621a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c54e890e1e2a28b6afa9f9874b7264399d86c80f66cee1c7e8e0c8c0856c0715"
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
