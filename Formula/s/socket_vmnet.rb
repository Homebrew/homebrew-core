class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "c44600fb9d4a44d533cfb5fa530264576952e887b065fd0b04aeb2500c812055"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abf253d7f02054144c432149d1b2804ef3253fffecbdfe0e0942803b794765fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48da13f47e4a044477b9915228d2ed3e8224acfd904ae3bca815c6e394b2863b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "276fe910d33ed629f084b717d44d32bae1d3fc3aa13216be47bb1f2798ce5d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "effb03fcd56b6762a2031edf337c8f3261da6b16b45b081635ffe891090e184b"
    sha256 cellar: :any_skip_relocation, ventura:       "72fb6bd3a1d7aa852e052529697f675b216d1b718db94281fcd5062bae9afbc5"
  end

  keg_only "Homebrew's bin directory is often writable by a non-admin user"

  depends_on :macos
  depends_on macos: :catalina

  def install
    # make: skip "install.launchd"
    system "make", "install.bin", "install.doc", "VERSION=#{version}", "PREFIX=#{prefix}"
  end

  def post_install
    (var/"run").mkpath
    (var/"log/socket_vmnet").mkpath
  end

  def caveats
    <<~EOS
      socket_vmnet requires root privileges so you will need to run
        `sudo #{opt_prefix}/socket_vmnet` or `sudo brew services start socket_vmnet`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  service do
    run [opt_bin/"socket_vmnet", "--vmnet-gateway=192.168.105.1", var/"run/socket_vmnet"]
    run_type :immediate
    error_log_path var/"log/socket_vmnet/stderr"
    log_path var/"log/socket_vmnet/stdout"
    require_root true
  end

  test do
    assert_match "bind: Address already in use", shell_output("#{opt_bin}/socket_vmnet /dev/null 2>&1", 1)
  end
end
