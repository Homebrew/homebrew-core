class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/78/2b/1e77800918dce31e99c84a26657a01e1544cbf2fa301a27ac45872872c55/xxh-xxh-0.8.12.tar.gz"
  sha256 "0d71c0e12de2f90534060613dd24c4eb7fb1d7285566bc18a49912423b09f203"
  license "BSD-2-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47172f4a08d3248a5b3dbd761da8ebc0e050a0394cdcc09d283b269aa478bb40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03bf2c78dd77992e5e82bc089f58617c5165c797b56b0eb8d6939cd780cf3c60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5db9198a94336a94b70bb322855ad5789d709c64be0b3bed97071f9796d90b71"
    sha256 cellar: :any_skip_relocation, sonoma:         "e59e595e1348f7181c9a56e7cf81b9755a47232e7d875802a6b94ce8d6fb1ba8"
    sha256 cellar: :any_skip_relocation, ventura:        "4bd73a9b8bd76f2ad74ec9c9dcf77565eb4c92a5858c3a5a0cefa2e3a8594c36"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a117e7ab19bff1602f79914f5c2ff1c33e5d1426e16fcfb188a9b315683f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9cb19657f532c1b92df2981188d98bf222f7241e0db5383f40413f8e0ac4100"
  end

  depends_on "python@3.12"
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
