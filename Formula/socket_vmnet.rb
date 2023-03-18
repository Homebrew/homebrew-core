class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "d7c2c9322e38b63e533806b2d92e892a3155fddf175f7bb804fd2ba9087d41cb"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f5a3c9fe4b2c1194232be3b66d88bc527f115d9c34ec1da288d7d5f709352f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a6c4bb0974e5c724894a450b93722410f6c6dff23f86c55d8e4e78da3e2b788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d432aa75e3181a255655cc37e63386d797e4db2bd86275f658cd91ae46978e7a"
    sha256 cellar: :any_skip_relocation, ventura:        "985252b80ad35b4ab0e9f3eddd973d26fb76c90f033fe7ebdd369a461af30121"
    sha256 cellar: :any_skip_relocation, monterey:       "83690ef40370e4b7155450a72326cbac6fc14169bc36fd824a5494f74ef88721"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed57ff746e0dca70e6d38564dc4158ef6034726c601493cffcc0c765576b6b7f"
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
