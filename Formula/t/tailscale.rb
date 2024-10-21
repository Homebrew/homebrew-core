class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.76.1",
      revision: "24929f6b611127cdc40d45ef40d75c6afc1fcc4c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f0405cd88e59a574a94cd18150c42645aac9cfb979461ce99b42af2eed85b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00dcf4299d757b35e7937c74b62cb43485df45bcd3e1b4aac1e18c2760e1a0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8214d30a74a5ce5cbedc5dc901191e41c750e2ac1cfb17be9064abb0e0115880"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b2f0ca7cdc6863ec279961ca0fcc7acdb5d494a9cafea28259517872ff3d29c"
    sha256 cellar: :any_skip_relocation, ventura:       "a76da251f0f75a0760326b25dc45d7317dc3f0d3cb4680e87de45154be70a08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d220fa39c19bdaef8e5b6c50d6dd0c49ece2d9451d39b052d16a23c814715e82"
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
