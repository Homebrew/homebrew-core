class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.96.3",
      revision: "bf309e40002f482217865f1ef47803f5e6768614"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2ee979c18bb376a09d47ca26b263d082f87f1fdc54b455ebd63ab3ed2826c36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89203afd4f7b5e5319cbd145ecb76619b97f59a8f606c927ad142bceb21022e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8c1053ed3e08dd1fc868966fae900f455926462285dd27fc1d5fbd9a54066dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4172b6fb4bfc914291399dcd143369c637351b15d4e0b1a5e68d7b625ca4bdd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3f25cc8c585ffd7424ec2d323fad1cf9562198f38d0072aefd8de990e4e680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3fd78fcb83e8e123ff0df22e017849ce969acdbce8233f5e54410556a615bfc"
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
