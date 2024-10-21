class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "e2a305e2a1bd018eb371693fab7891fa38855ff9ac9c1ab4210c0641868e344f"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae4d03f3a49eb4e01a5ae99292f7fdda8d81b248ee3fca6be5233f5c37bd1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64f8c1a507264e023cdae80b30a32e9d57586707e67b4e9690b47859a90baa30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cf43d084796df6a598de4eb9780dfe7d5e908f7eb042f3b4954bf43bd9569a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba13f5d706bf052efa1f4d23c14d72ebfc9994f951c266f310a86d4a04bd5a46"
    sha256 cellar: :any_skip_relocation, ventura:       "e4c42a22be5e748d1147364f1aa837089a3a3b8023df447f3531929253582ed3"
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
