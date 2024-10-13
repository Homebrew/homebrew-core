class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "2abeb0510f495ffcc114b6fbdc1f7c92cc87832970b285038f1029c0294d6fdd"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "340765da735e3f033b0cf09fc439f3157eb96a340305e9bfefccc19e6ea31f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afe451de9b6a438b81c0c7828b0cd4b320a18e7f51468559833682c376059088"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3df991639d7ecd68d3d5c7beea8d49af2b339e5889b7e365cbe810ee6852baaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bd4b33d299b8a70630a86f2d49e464199e048df22a8094d18199edcdc0a481"
    sha256 cellar: :any_skip_relocation, ventura:       "7e8b732c98054229755cd83a58be7becfa94acb0555c061333cf44b68ce6e614"
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
