class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.62.0",
      revision: "cc950c079140abfdaaf69777fa171f0bcfa63598"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1785b86d5ecc3323d20a18da12aeadb3201f43d6886095078190c9ac091c1b1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f89390571a2b8e39de1ca417ad456e0eaa173bfe377b637faa07ae6f0c72f753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb055a9b1bceeee54e7531482f79bf3fd2d31e41434c0a8e39322dc69293f180"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7d04aa815fce539cadd7a088db94fc4cd0f346bf7362dc744e16872805c66c6"
    sha256 cellar: :any_skip_relocation, ventura:        "45f85da72c0439a0008eb83624166eb39cc5b0597b2f065716a1bb905442535b"
    sha256 cellar: :any_skip_relocation, monterey:       "2f117c67bf5ac2c79ec3ec32037c1c45c150155f23b4479518f8004dbda09f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b53c1b6b72750e0e9aaaaa8d7c1dc43b26b2c728419ec4eba14862451bdd31ad"
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
