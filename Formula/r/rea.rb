class Rea < Formula
  desc "Reverse engineering CLI and MCP server for agents"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.9.0.tgz"
  sha256 "322338a1505e2557702a16012e7d46abdb5729641d98938662762dfbfb79262a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e2c29c7a339a0767113615640ebf91b47296408bf29483ed649bcfd38d51c2f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2c29c7a339a0767113615640ebf91b47296408bf29483ed649bcfd38d51c2f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2c29c7a339a0767113615640ebf91b47296408bf29483ed649bcfd38d51c2f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "376dc1489619e329e248ffba13ff0531b58798f277bdfb80d0490220928fcc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "376dc1489619e329e248ffba13ff0531b58798f277bdfb80d0490220928fcc1c"
  end

  depends_on "node"

  uses_from_macos "sqlite" => :test

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/rea-agents/node_modules"
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    rm_r node_modules/"frida/test"
    node_modules.glob("@lydell/*").each do |dir|
      dirname = dir.basename.to_s
      rm_r dir if dirname != "node-pty" || dirname != "node-pty-#{os}-#{arch}"
    end

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
