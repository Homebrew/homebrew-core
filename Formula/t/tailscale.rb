class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.68.1",
      revision: "92eacec73f10616b2be7aae7a1ac53c8e44e9268"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb7ce9b6a4234669a81752aaf2ed7d6a066c72e4b8781543c43d0956b81a5d1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60e1a248ca5ae576a1dbf3cbd0176756e1872fed6a36ad0b81d8bc8a3c8979c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2c0b671925f3418b6c3dc669e0533d0df2709c7125fa2fb545eaa542386226"
    sha256 cellar: :any_skip_relocation, sonoma:         "a6f7e94946abb16eff20c8070bca5d9e9bffed9c25bbd606f2795dcc822f2d6d"
    sha256 cellar: :any_skip_relocation, ventura:        "7c8f5d7e0fbb8e4de6a6756583ecfa37419e597960e7eb94f44a2b9b266f580c"
    sha256 cellar: :any_skip_relocation, monterey:       "1ebe854bacb8eb39869dd205c73b0300e780c81671a5668eb744dcb9260fa110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873df22e03a9a6d9fbb6b73ba7851ccc5bfec5668ceaffcb46049cc2a89dd853"
  end

  depends_on "go" => :build

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
