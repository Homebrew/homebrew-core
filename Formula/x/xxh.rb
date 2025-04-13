class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/d6/ac/fb40368ff37fbdd00d041e241cc0d7a50cdac7bc6ae54dcb9f1349acdde6/xxh-xxh-0.8.14.tar.gz"
  sha256 "7904c35efdff0a6f50f76b30879d3fbfe726cc765db47a1306ab2f19c03fdfae"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "91c67ed304dd2ff1703b87750f81b35238e051b999837ad62b1fdef026b8681f"
    sha256 cellar: :any,                 arm64_sonoma:  "90fe8579c1a9494c3cd230237c8858e907f8d609dee2d467b04b7f3386a4d765"
    sha256 cellar: :any,                 arm64_ventura: "58f728daf50085a2789ff3e60aaa79c9bdf8311d81a72229db17845339d27b23"
    sha256 cellar: :any,                 sonoma:        "e84bf6a6f1ec3a8c64808143699230cd051658b93e41392229f89b435dc935ba"
    sha256 cellar: :any,                 ventura:       "21ede13f1c2be72389b89d535d878bb67df550bad7ac5e738117fd0517b10802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3040b653b3eeec14c4875be095568480975c537ea9bcbd8db3f2f9f3b2a2326d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2335bd805b3ec23dfbc6f32bef599e4da99420c48b0676d055050ca3d5f7de04"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
