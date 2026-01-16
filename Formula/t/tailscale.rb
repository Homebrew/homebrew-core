class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.92.5",
      revision: "b1eb1a05c38c7ea682ddbfcdbd2112304f880d9e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5a7b36d019b443dc72e1d0058dffed886f3837fa0e73e21dabf185d3dd0150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a8fefe0de4500bb8ae8ecf6e5b79a9fe62488689e671f7cdad12fdd2af7d0d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c6a81379790cf7563179e0c1f652266734f9b56c06de0e742597f16e7ad0ba8"
    sha256 cellar: :any_skip_relocation, sonoma:        "303c203e51c59073e6b5c4d9d78a7433970aeff4cb44dec365a886ec61286438"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7501496f35df70247a00e1ce157f64426049e3d3132b7aa4ce322777bdad336e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b97ae0624503c99a357e0451bd1cd093df3bd2c5a92df33a9e7275843d9674"
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
