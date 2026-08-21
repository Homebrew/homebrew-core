class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "7341cab86654a171a427799f9e472696dad17215641c39c4b26de8d2181933a0"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3120039f523d59fe299b4f3595b0db5f59af486def3c7108ffe22579292227e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8734ebe53397638b77dd5bf51c15cb6eaf4aabf297a315868bef2ef6505c31d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdbf14d02df41c08c6e6c54059df2138133af4864e6709b37c10ac1a94c0c279"
    sha256 cellar: :any_skip_relocation, sonoma:        "3248770360fa1ea37347b33fce263982e0362e7176c253d5bf7e4e41443f9c79"
  end

  keg_only "it should not be in Homebrew's bin directory, which is often writable by a non-admin user"

  depends_on :macos

  def install
    # make: skip "install.launchd"
    system "make", "install.bin", "install.doc", "VERSION=#{version}", "PREFIX=#{prefix}"

    (var/"run").mkpath
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
