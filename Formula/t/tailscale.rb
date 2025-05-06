class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.82.5",
      revision: "e4d64c6faf827a308ec20b39651225178e6743c0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cb9522e6fb472254456d3d3879db2cbb4fee351e5879b4558f2dfec05751003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "534cbaab1cc979ff683f3931aaa8a201a0115e13e7e5809c8f03b145c6757119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7940891b6c77ddd1ca3bc8ef3f53ebff37ae5f57b96a5eb8b76fdb903df6e93d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc467f4068ed000de01e618be1988ebcf46c5c7e085748791ebe72e3fac8d5ed"
    sha256 cellar: :any_skip_relocation, ventura:       "64841fc4262a93c285bd88960341173800327bf01f6a16be9fad7e65c51b82c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef09a917c922fe6d10174957a2255fa77c34e01f2df81c572ca23133b3ec329"
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
