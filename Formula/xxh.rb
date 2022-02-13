class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/63/71/7b985e754543e4fc9fc53cf36f405ee5b8044931cffa45898c4edf74275a/xxh-xxh-0.8.10.tar.gz"
  sha256 "5afe1d9803143e3b6659f48a6e4ec8134b952046e8efd9089b791aeeb8fe1045"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "639a6aed5f3aa286bcbce5259504aa6edb3b9d1620c753b07e21c715f493fc45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f396bc52bd61b46c139ea378b0e38dd3137a2772cfc0ed43fc98a3be59693f61"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5f2a2a841e545cf824876b8d7d1ef3ab583d168f52b2753b3ec19231a67123"
    sha256 cellar: :any_skip_relocation, big_sur:        "f38b8f4b5c4716c241347cbd945c0aed4e98585e04dca8bef5d55aca53268d02"
    sha256 cellar: :any_skip_relocation, catalina:       "ed4fdb6cb0e7b4191631b7c92fd51cac5047dc5d299e7a7e09e0522e294830ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce4f48ddd84c4fc23d39007230c1e3cc9734f391b8c749258fc577ec55635215"
  end

  depends_on "python@3.10"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xxh --version")

    (testpath/"config.xxhc").write <<~EOS
      hosts:
        test.localhost:
          -o: HostName=127.0.0.1
          +s: xxh-shell-zsh
    EOS
    begin
      port = free_port
      server = TCPServer.new(port)
      server_pid = fork do
        msg = server.accept.gets
        server.close
        assert_match "SSH", msg
      end

      stdout, stderr, = Open3.capture3(
        "#{bin}/xxh", "test.localhost",
        "-p", port.to_s,
        "+xc", "#{testpath}/config.xxhc",
        "+v"
      )

      argv = stdout.lines.grep(/^Final arguments list:/).first.split(":").second
      args = JSON.parse argv.tr("'", "\"")
      assert_includes args, "xxh-shell-zsh"

      ssh_argv = stderr.lines.grep(/^ssh arguments:/).first.split(":").second
      ssh_args = JSON.parse ssh_argv.tr("'", "\"")
      assert_includes ssh_args, "Port=#{port}"
      assert_includes ssh_args, "HostName=127.0.0.1"
      assert_match "Connection closed by remote host", stderr
    ensure
      Process.kill("TERM", server_pid)
    end
  end
end
