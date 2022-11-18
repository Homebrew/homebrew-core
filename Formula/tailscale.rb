class Tailscale < Formula
  desc "Easiest, most secure way to use WireGuard and 2FA"
  homepage "https://tailscale.com"
  url "https://github.com/tailscale/tailscale.git",
      tag:      "v1.32.2",
      revision: "54e8fa172b725b354598daaa7007d261fd932d10"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f3ba668fe1fb8054537b62833c3eb6c9857041035db3cf23d4ae49310d1402a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97fa451873fbb56978ed710ea16ea2984a84730480be03ebec13c245ebb3ebc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49ea942a92327761c9e1417fa404a5510934b21c6186bf8b4a362bab68384319"
    sha256 cellar: :any_skip_relocation, ventura:        "32bac9d455c05788afda232019477ff87f258e8cbb68b99aec17ea24a01621cb"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc4089591d40084a0d3a29a2881bf7cf81c8255e733668945f1e3cc12cc20dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d337ebd2164f7e8dc1bc23b73cfce78febf41542a677274edb6e9d823f540bf"
    sha256 cellar: :any_skip_relocation, catalina:       "f8674fe5c11a0187c3f2449b0f4290a088d0526dd7548265141f9ebb278a911b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb6aed3238ad126c2889ebfb6bd78bfac9556539ae0d7756a1123641b05cf5d9"
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
