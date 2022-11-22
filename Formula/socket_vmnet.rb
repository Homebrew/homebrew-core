class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "da85362518c4ccfef3587240d380d52d7c7621c4567f1d9a476e1c17c5a7563b"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  keg_only "#{HOMEBREW_PREFIX}/bin is often writable by a non-admin user"

  depends_on :macos

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
