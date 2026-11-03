class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.104.5",
      revision: "73a48057aaf5f60e4f770b398e9b7af576b01dbe"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c66667d1e286974def6d8f43961340d17b9b67691b2542907d41854fd8e65a99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "17f794d909751d589a7ce7a0eb8fd9bfafa126480f7f0d1c60a1e1f05d871e9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f00eb99929bd0ee0562142d88234e8c6f7c15ed82f831807c816b52464d98620"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08e157bba434ef163d4c2575a3832ad9acba7cf76458d321e84a5acbcfad8295"
    sha256 cellar: :any,                 x86_64_linux:      "88b239236e19b2ff9d3b9cbfacf59f35fbc7dd87834dc33600144655f857f853"
  end

  depends_on "go" => :build

  # `test do` block runs tailscaled, which attempts network connections
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -X tailscale.com/version.longStamp=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.shortStamp=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.gitCommitStamp=#{vars.match(/VERSION_GIT_HASH="(.*)"/)[1]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tailscale"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tailscaled"), "./cmd/tailscaled"

    generate_completions_from_executable(bin/"tailscale", shell_parameter_format: :cobra)
  end

  def caveats
    on_linux do
      <<~EOS
        tailscaled needs root privileges to configure iptables/nftables and DNS.
        Start the root service with:
          sudo --preserve-env=HOME brew services start tailscale

        To run without root, use userspace-networking mode:
          tailscaled --tun=userspace-networking
      EOS
    end
  end

  service do
    run opt_bin/"tailscaled"
    # See the caveats for userspace/non-root mode
    require_root true
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
