class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.102.3",
      revision: "53a0d659afa51835dd7a9283873cca44261454f8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05df4570550a22685b8c237c90efd53313fb72d27277f530fae15841d05ea15b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca9c36e9c17ec9f098447e6957ed1862fe12f4c727dc7dccc460106f286bc087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c67806a1fadef72641f73e214419fbe9589aa96952a7d99d42f0b4393ae23b"
    sha256 cellar: :any_skip_relocation, sonoma:        "30d20988a55dd0afb46fb6e4fa2f64d0885ba6f07d2506872435c40881037aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "719be1169e342f835aaccdc3fc020c7ab7abf4590f43d4081a027b64d59a4888"
    sha256 cellar: :any,                 x86_64_linux:  "cdf2399665e752c51c1010db0618fa034643bc2b2c49e7dc0eeee10728b8add8"
  end

  depends_on "go" => :build

  conflicts_with cask: "tailscale-app"

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
