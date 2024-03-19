class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/78/2b/1e77800918dce31e99c84a26657a01e1544cbf2fa301a27ac45872872c55/xxh-xxh-0.8.12.tar.gz"
  sha256 "0d71c0e12de2f90534060613dd24c4eb7fb1d7285566bc18a49912423b09f203"
  license "BSD-2-Clause"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sonoma:   "b3012b1db3b309e4159e55c9dfefcef33a1ceeb08670b81a145474e9bfc952c0"
    sha256 cellar: :any,                 arm64_ventura:  "81fa47b11e767a7f35404c478f683c899e7dcd46fbab154ad2eb7072e9266ccd"
    sha256 cellar: :any,                 arm64_monterey: "b77da2f3dd1a2662c670ae29e488750caa88f1d0db2ca01f256b9c8c7ac52869"
    sha256 cellar: :any,                 sonoma:         "f50ed216c52cb02b30b81ea58464f3232c1cf18b96cffe896a31ce1e41c5213b"
    sha256 cellar: :any,                 ventura:        "8b20978c6b182857fe4cdd2bff5eae291ee40b3163e30402c48b0930488ed063"
    sha256 cellar: :any,                 monterey:       "632f996ce8a44d9066ebff1614e2f8f0f78fce62bc0e4f7b78244a8d8026b1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7ad3062974fb5ef5e7c3a130f5256cd4622c3d883af790c28d4b8494dbd1fc2"
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
      assert_match "Connection closed by remote host", stderr
    ensure
      Process.kill("TERM", server_pid)
    end
  end
end
