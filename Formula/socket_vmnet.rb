class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "d7c2c9322e38b63e533806b2d92e892a3155fddf175f7bb804fd2ba9087d41cb"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01ab44a93ed874d4500ac8a7f8ef44252fe5ff96a2e78df35ed4c4da837b848f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da933499a674b796edc643629ecc50382fe13057e86d86173fbcb9878b649cfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f1a4c54f294dfc2851218b0cf1432120e606c84e577d065a9e3caac5660ab36"
    sha256 cellar: :any_skip_relocation, ventura:        "113fb0d997b92520557a7430bd10695c17099d55308cd5ee731c0b386d749b94"
    sha256 cellar: :any_skip_relocation, monterey:       "fcd1d497e67e89debad36400637317534338de174ed7c7876bd869e9e9efc09c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb87bb0eaadd73398fcde0924b3ffc49c67354267474d8e89788d58191b980d8"
  end

  keg_only "#{HOMEBREW_PREFIX}/bin is often writable by a non-admin user"

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
