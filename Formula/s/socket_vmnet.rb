class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "38ee9a3aa6e990ae35128813d6927b64f95bfb5b9e13f8ac8885ab71394499b8"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3fdabd6b7f9902acebb939a7e291ea5f97f3e36aedf1e8fb3a18c0b1fc6c8eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8597587e961d4482d83739489badf3cb8c6a75402692d613c045229203c8392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6c24f2176c97e6061015d76ad48a1c468f85b3c4198fa4f2d0e43d229a50fca"
    sha256 cellar: :any_skip_relocation, sonoma:         "565371131fde789b35b61c90ebfdc1f97295ac36b8732fa9ef850e02610af506"
    sha256 cellar: :any_skip_relocation, ventura:        "29533f07316e19eb86a4a0e1986185c059344df516f8798c2056ca7128e3ea01"
    sha256 cellar: :any_skip_relocation, monterey:       "1339b46316025f75bd1206d941c399155b0287422b8ac5e8c5bedeb84458e3d2"
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
