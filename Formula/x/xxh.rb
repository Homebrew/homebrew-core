class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/78/2b/1e77800918dce31e99c84a26657a01e1544cbf2fa301a27ac45872872c55/xxh-xxh-0.8.12.tar.gz"
  sha256 "0d71c0e12de2f90534060613dd24c4eb7fb1d7285566bc18a49912423b09f203"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a69d8012317f6d887403af6695817e8f68ce8b0884132a6663b72aa6946e4c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b38d55cda2bcd7b4bfe898f42585c6fc8b30865439c7126262b3a5a3fefe4fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acdf2d90e74d9f9a695cb28f8397ed5b04ced16cbd5898b14900354e4fa7f573"
    sha256 cellar: :any_skip_relocation, ventura:        "e6aea90d000df6897044aeb7f32cc4680b674a7b2ea5b3fb9ad5116d085aa811"
    sha256 cellar: :any_skip_relocation, monterey:       "21164a6f91fb009f97f9754ff294423dc683c55e510fdf4bdc9bdcb49e5f55f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c39f3328e4fd3120da656889b62fed687d7406d2e012f46c14d82fe0d40f9b8"
    sha256 cellar: :any_skip_relocation, catalina:       "1027b023243ac643cda97f528e06f13da5bcb59861acb7c596806f77001b8cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f27a4c3773d9f2fe00f3582e1b10a9b37717b729b6ba7c1f2fc84e9ea6d4a0a3"
  end

  depends_on "python@3.11"
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
