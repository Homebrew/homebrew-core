class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "0c0c8670d7512f75a427df601a4d15b7bef888e07c8f54adce83a5d8be1423a4"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b80c0b4a8d5d9ec994161b7ccc3a712238bacf200e1ea3fddaaf32dc9706725"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edcfe4eac3bc20de7cdf15e62f420aef9b69ed2510aa725ad30b49087b2ab53c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c8593ba13dff05be5a3432b7a92da5526f12097bea10329f4c6b9ae43311725"
    sha256 cellar: :any_skip_relocation, ventura:        "b8f647a42a7d6cc4ef91ece3f641a427c06c81645a9c04a80a71b0441f204885"
    sha256 cellar: :any_skip_relocation, monterey:       "a3569285d7af1b1d8cdb14d3e4f456287c9fc5f082d890f9917f335eee957213"
    sha256 cellar: :any_skip_relocation, big_sur:        "730dc7cbe4f6686591dd909733d764e33e0ef3dd7dcae3e358a0f09f4a263715"
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
