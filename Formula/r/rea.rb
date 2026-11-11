class Rea < Formula
  desc "Reverse engineering CLI and MCP server for agents"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.8.0.tgz"
  sha256 "8d542ec76a9cb350584b60a6c9c088706ff812d5bb5b094c20c95b6dc25698bb"
  license "MIT"

  depends_on "node"

  uses_from_macos "sqlite" => :test

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    rm_r libexec/"lib/node_modules/rea-agents/node_modules/frida/test"
    rm_r libexec/"lib/node_modules/rea-agents/native/windows"
  end

  test do
    create = <<~SQL
      CREATE TABLE greetings (message TEXT);
      INSERT INTO greetings VALUES ('hello world');
    SQL
    pipe_output("sqlite3 test.db", create, 0)
    output = shell_output("#{bin}/rea inspect-sqlite-database #{testpath}/test.db " \
                          "--table greetings --worker-timeout-ms 90000 --json")
    assert_match "hello world", output
  end
end
