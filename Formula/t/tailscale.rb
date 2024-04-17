class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.64.1",
      revision: "02a96c8d7c0e12d8e34d7b712ec56f856fb275ce"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fac5aaa24cfdb7c5445b8fe9b6b5d9439c4f6fb3ad7b2c11e6779822a2d6070"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b54894006075f16881dd9b4553e405692fa6af5c8be3da1b799d32b1480e489b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44d8cf9b5881cfc1622f51fa3ed4da31da9be56e821741f1a31d3a15787f40d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d165da96732a8267b25c39c2dd03bc13cd0171ff19102682546b9e75822ef4c7"
    sha256 cellar: :any_skip_relocation, ventura:        "34052ef7cf3f5d5a0924e42c4a54e20a164ed66760c71e78c8ae9a10b2bce621"
    sha256 cellar: :any_skip_relocation, monterey:       "f1ce3152407ea31d2e7f99feb3ff0b11c8e44e97cc338625a6a76395bd83f0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d7fdc565640a111adcf00685f6848ccf98856c258040a74b4758cf0225d5f37"
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
