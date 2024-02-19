class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/78/2b/1e77800918dce31e99c84a26657a01e1544cbf2fa301a27ac45872872c55/xxh-xxh-0.8.12.tar.gz"
  sha256 "0d71c0e12de2f90534060613dd24c4eb7fb1d7285566bc18a49912423b09f203"
  license "BSD-2-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1fdd512d99aec1b22fef3ce3a0a2a3d462248148955f4c7b5d6f66deabad336"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39f68a86fee8c7978b6f603d451e4fc4ba1e4d9ebd8ecc37e00a30ee74cb5b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a69735bc502f761c7873b62e351c3bb566a0faa6a221611e2ee0d83a92e3a02"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2dcee2e28678c8947d67881d1541336d95dfc7a25883bf5016668fb651fc523"
    sha256 cellar: :any_skip_relocation, ventura:        "0ebf95d37797d5eadea31f50d943ccf311a25a9212d96da0437aa3275b8695de"
    sha256 cellar: :any_skip_relocation, monterey:       "46756d1f103241ebb5cc8ba9717966a21eae5faca797be0def13804c93e3acbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d46b88f0638507261cefa580dd2c5fa6db540efd2222b4f6af5550585280918"
  end

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
      assert_match "Connection closed by remote host", stderr
    ensure
      Process.kill("TERM", server_pid)
    end
  end
end
