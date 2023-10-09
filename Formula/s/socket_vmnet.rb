class SocketVmnet < Formula
  desc "Daemon to provide vmnet.framework support for rootless QEMU"
  homepage "https://github.com/lima-vm/socket_vmnet"
  url "https://github.com/lima-vm/socket_vmnet/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "7c7495212fd25883ea877d54cccd33875aa8a908a91bd2a08bfe1177219a086f"
  license "Apache-2.0"
  head "https://github.com/lima-vm/socket_vmnet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f901ed4594c8248746b09230314406abe0a1c72dcd3a605e373021c04a5fcf98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57e331d111136798213913e96b05501a7cb49af187ce9935a7de0ece824fe16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "808d4773763b7ced602aeb58dbe9c41123053a893a9dad388d054a048de8f4b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "17cee33cc7e78ac60b9f240c3279961e4c27f82b52a1ea22c2a6dd0bc121b322"
    sha256 cellar: :any_skip_relocation, ventura:        "069e32b9dca83f6efa6ed778284340701fd1b4377e86341d21d417ce099c2e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "439bade17882535e25dc54076a721f9e467dde7e3b53685b867c19c1d863a959"
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
