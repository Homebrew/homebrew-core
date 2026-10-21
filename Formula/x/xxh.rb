class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  # TODO: check if we can switch back to PyPI in next release
  url "https://github.com/xxh/xxh/archive/refs/tags/0.8.16.tar.gz"
  sha256 "a8100a831049be3131146da6a26d8cdb2fb15afc8d637521fcbdba37a3429a50"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "43ffd6bfd6d48c4045309e9f2cf1913dff652797c5ff96aa08cd2b7896dab794"
    sha256 cellar: :any, arm64_tahoe:       "c1a547e72717040e794c210a7d4e26220062dc39f9a27a3b84f78ef4f16745cf"
    sha256 cellar: :any, arm64_sequoia:     "6d70f92dd850b2d888181945c58f678d171a386a4286d98e3773dcf7609de39c"
    sha256 cellar: :any, arm64_linux:       "dd978859c9f1f98235abc247aa4ae550d6b8cecf43ec283460fc6aa92d487c00"
    sha256 cellar: :any, x86_64_linux:      "7f788beb5e72d70cbebf2e193b84c16088028950e79fd9c0c58750ab5e59c1da"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xxh --version")

    (testpath/"config.xxhc").write <<~YAML
      hosts:
        test.localhost:
          -o: HostName=127.0.0.1
          +s: xxh-shell-zsh
    YAML
    begin
      port = free_port
      server = TCPServer.new(port)
      server_pid = fork do
        msg = server.accept.gets
        server.close
        assert_match "SSH", msg
      end

      stdout, stderr, = Open3.capture3(
        bin/"xxh", "test.localhost",
        "-p", port.to_s,
        "+xc", testpath/"config.xxhc",
        "+v"
      )

      argv = stdout.lines.grep(/^Final arguments list:/).first.split(":").second
      args = JSON.parse argv.tr("'", "\"")
      assert_includes args, "xxh-shell-zsh"

      ssh_argv = stderr.lines.grep(/^ssh arguments:/).first.split(":").second
      ssh_args = JSON.parse ssh_argv.tr("'", "\"")
      assert_includes ssh_args, "Port=#{port}"
      assert_includes ssh_args, "HostName=127.0.0.1"
      assert_match "Connection closed", stderr
    ensure
      Process.kill("TERM", server_pid)
    end
  end
end
