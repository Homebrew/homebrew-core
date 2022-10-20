class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/78/2b/1e77800918dce31e99c84a26657a01e1544cbf2fa301a27ac45872872c55/xxh-xxh-0.8.12.tar.gz"
  sha256 "0d71c0e12de2f90534060613dd24c4eb7fb1d7285566bc18a49912423b09f203"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "446336f5a7b6c97b0177e18b24e747185aa0ecc3c646c33362ed7d0da18fa9db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76ac0429c95651dcdd5e77e25cf2cb8c7eea2c5a51d325bba732134194bb4ccd"
    sha256 cellar: :any_skip_relocation, monterey:       "a32fa38756ce00eff965d95a1934d029239b1e3e6f145cd245b5d3a8ddf6e82e"
    sha256 cellar: :any_skip_relocation, big_sur:        "636df308c6af492b13887cbe1bb800917907bbf88369b714301338a9d86829d5"
    sha256 cellar: :any_skip_relocation, catalina:       "e9561157cb31685ab22b598a607bba6fedbd2c16acaffcb825d5de38441f9276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b09727a268fd6be41bbe67bb6b24d6eabc891f211a1bd9d806539bcd65fe5725"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
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
