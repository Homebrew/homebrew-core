class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/d6/ac/fb40368ff37fbdd00d041e241cc0d7a50cdac7bc6ae54dcb9f1349acdde6/xxh-xxh-0.8.14.tar.gz"
  sha256 "7904c35efdff0a6f50f76b30879d3fbfe726cc765db47a1306ab2f19c03fdfae"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "822e1666ce2e955c53623bda48f314623bd13acc5ba4aa6f3a0ddd1caf47ea4f"
    sha256 cellar: :any,                 arm64_ventura:  "506b28fef997d22a9758465f16f581f50d6930910795959552a22e950069a4fd"
    sha256 cellar: :any,                 arm64_monterey: "b8a409e38956b865d25c45dcb45b77cd2f2241a8a26bbb0022a94afa1fbae6a8"
    sha256 cellar: :any,                 sonoma:         "5fa1b2366a20659838f63c3677cd33ada1fc7c720424ed5fd7b1f9a2fb0e25de"
    sha256 cellar: :any,                 ventura:        "9503143a0ecaedb5d2890e455bea5842875b465753ada89a8222b8ea45a4439c"
    sha256 cellar: :any,                 monterey:       "3d160118d09b9b87dd435f9874442a56377bb68dccf916e26310201e4e48823b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9cd1234bba4387ec033284cce8258ca2e6ae6911dfd7efe50e277c7c06be975"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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
      assert_match "Connection closed", stderr
    ensure
      Process.kill("TERM", server_pid)
    end
  end
end
