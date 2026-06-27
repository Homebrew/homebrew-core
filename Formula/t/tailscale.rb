class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.98.5",
      revision: "295179bf294d3d076397bcef6815b1d6854e197d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "720e8a9d94c52a7f994bdd266eac5aa74e551ef6f1237bd9b079a0dab56fa06d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9d6646ffd507d665a536ea75b4f9b6b42c2afd8b63d2aaacadc680f92813cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c0f4a13c6264b44be55fc830b66d59ad4f3e38cdfe91e96b8795ed1dee963f"
    sha256 cellar: :any_skip_relocation, sonoma:        "643a77ae9202b5592c45bb0bf57aaf38afdf2e03b35779ddefd06eb326f38e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16119e57b69b915099b340f04e1a17bd67fe9f5f0ce0c078802d0e241e823b0c"
    sha256 cellar: :any,                 x86_64_linux:  "cf7d1fcb1d8ce110a2d22ebeb7ef321bc9c7478d000645f0cd3bcf7feca303df"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

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

    generate_completions_from_executable(bin/"tailscale", shell_parameter_format: :cobra)
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

    spawn bin/"tailscaled", "-tun=userspace-networking", "-socket=#{testpath}/tailscaled.socket"
    sleep 2
    assert_match "Logged out.", shell_output("#{bin}/tailscale --socket=#{testpath}/tailscaled.socket status", 1)
  end
end
