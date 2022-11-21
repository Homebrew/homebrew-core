class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.32.3",
      revision: "9dd89b8c263d8a15dec313ea3ce77a6f2fcf2aaf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "666d7a203842f683543ba554c497138aece3ca4e9bc6774407fa4b9c2c089e35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90caab2b4460e5cbdf86af6763498fd6b3399f8da7bc6ac05fa6e255e94d723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95a94433fc019fbe0efd856d34485fb334308606601af4c22e5c16d7d1db8b90"
    sha256 cellar: :any_skip_relocation, ventura:        "df29c3709c93ae742c8bbed13d1dd48f3a5937352d588885a9c2b2ba1da3a3a0"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0d01f08345544f3285c62d61b2e3d6ea07fdc81be9b0fa54d6c2f133bf9181"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc2d41e7d3329dbd48cd549d975eac381113602589358c528b85212331673c34"
    sha256 cellar: :any_skip_relocation, catalina:       "3df2585a8e00c64435dac5514ed0d0935747d999df348f799dafbcfbbe8ad907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "907616c211c0e4cf18697041b0eef872f678026184cfd9e8eeca20b1b6a249ad"
  end

  depends_on "go" => :build

  def install
    vars = Utils.safe_popen_read("./build_dist.sh", "shellvars")
    ldflags = %W[
      -s -w
      -X tailscale.com/version.Long=#{vars.match(/VERSION_LONG="(.*)"/)[1]}
      -X tailscale.com/version.Short=#{vars.match(/VERSION_SHORT="(.*)"/)[1]}
      -X tailscale.com/version.GitCommit=#{vars.match(/VERSION_GIT_HASH="(.*)-dirty"/)[1]}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "tailscale.com/cmd/tailscale"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tailscaled", "tailscale.com/cmd/tailscaled"
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
