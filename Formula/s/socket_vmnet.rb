class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "7341cab86654a171a427799f9e472696dad17215641c39c4b26de8d2181933a0"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15b3703e48a5f03c38e5f854d8c50dc24a532138af2fc94587767d19d7e2eea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be269d31b6494cf8c4b14e5421201409e7dbd63337046befd3712c6c926a8562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489e6807062d831fb5f961946b7f89576c8d48eaf35833dfb3f891f275294946"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c7d0037ddec9a8e178f8ac0dfa567a625be9412a690d42818b59acf5ea94d2"
  end

  keg_only "it should not be in Homebrew's bin directory, which is often writable by a non-admin user"

  depends_on :macos

  def install
    # make: skip "install.launchd"
    system "make", "install.bin", "install.doc", "VERSION=#{version}", "PREFIX=#{prefix}"

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
