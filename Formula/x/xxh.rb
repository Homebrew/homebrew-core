class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/d6/ac/fb40368ff37fbdd00d041e241cc0d7a50cdac7bc6ae54dcb9f1349acdde6/xxh-xxh-0.8.14.tar.gz"
  sha256 "7904c35efdff0a6f50f76b30879d3fbfe726cc765db47a1306ab2f19c03fdfae"
  license "BSD-2-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "07ed49c087bd4b82099ff25d213a71627a53d0c86bce7f95938a0072cf1e05ac"
    sha256 cellar: :any,                 arm64_sequoia: "9d00fc1786130a6714ae9b87c8d2477b4487605bc921fe37666c22d2794a73d1"
    sha256 cellar: :any,                 arm64_sonoma:  "15847d147ad2cc7806d50a69f2df443ca95a081a99222eac211d809047e57583"
    sha256 cellar: :any,                 sonoma:        "8a1313dff05fbd4a04345cc3c5782d2142eb07ad9ba0dfa21761d58363ac76c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f69ba9f8e23d52efd349c6d51cdfcd2dec59c8828b76589ba2a2a94765b58301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe168ea7da7ddf85fba4193337c1c4e60d52f0005fdc48c3510de8c35cef67b"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

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
