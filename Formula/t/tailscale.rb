class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.104.6",
      revision: "c54807352ae196919497b3f8fddc3cedf88368b9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "008224a34ef0687c6eba3c52445b60d5c8fce09ad1fa9bb30e60fa83a184d48b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "605102da5238824ebcd3eeb5b1f08c4e61370493f67971e9cab13816d65bf0f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6fd8201bd6632e607812e1be0cc0c754e8d6499ad8d7326eff93ecf0a15f17cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d14db7d4b80c0788e3b31f10eaaf12460206d836fff806bdc045d48d5855e780"
    sha256 cellar: :any,                 x86_64_linux:      "f8247ad4f74241069538d4416aa431239bc415ced9a130814648ec7d7dae0456"
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
