class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "da85362518c4ccfef3587240d380d52d7c7621c4567f1d9a476e1c17c5a7563b"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e309781893e7dd83edadee99ab08ec8295917f3e687f9c3949c95129be9ef03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb4bc938dda5c753ac0a741f290559f4864a10c298206b573fc103806e6abce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cafc6fea88ace7848811345919cfe2db0857d01a46dd55a1617719faa3ff410"
    sha256 cellar: :any_skip_relocation, ventura:        "9e144430bd06b3522662a8c97a52971df0de69f3161303de8c076882b478dd47"
    sha256 cellar: :any_skip_relocation, monterey:       "b3a238d313d1f0ad7ed813b37cf46e68df739c7a57062e6f545290307e8ce1e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e129b3422301ddccddcd30c312b86bdae105f43c8cfec06163404420201e0f5f"
    sha256 cellar: :any_skip_relocation, catalina:       "fd7fa82a159b2821a54bfe417968af6624b833f32eac6807e341536ffcab4ef7"
  end

  keg_only "#{HOMEBREW_PREFIX}/bin is often writable by a non-admin user"

  depends_on :macos
  depends_on macos: :catalina

  def install
    # make: skip "install.launchd"
    system "make", "install.bin", "install.doc", "VERSION=#{version}", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      To install an optional launchd service, run the following command (sudo is necessary):
      sudo brew services start socket_vmnet
    EOS
  end

  service do
    run [opt_bin/"socket_vmnet", "--vmnet-gateway=192.168.105.1", var/"run/socket_vmnet"]
    run_type :immediate
    error_log_path var/"run/socket_vmnet.stderr"
    log_path var/"run/socket_vmnet.stdout"
    require_root true
  end

  test do
    assert_match "bind: Address already in use", shell_output("#{opt_bin}/socket_vmnet /dev/null 2>&1", 1)
  end
end
