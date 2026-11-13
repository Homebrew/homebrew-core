class Rea < Formula
  desc "Reverse engineering CLI and MCP server for agents"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.9.0.tgz"
  sha256 "322338a1505e2557702a16012e7d46abdb5729641d98938662762dfbfb79262a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78568fc81d3b53c40230ea24ff07511c60d111c1291fda771aa47d9220e60dbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78568fc81d3b53c40230ea24ff07511c60d111c1291fda771aa47d9220e60dbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78568fc81d3b53c40230ea24ff07511c60d111c1291fda771aa47d9220e60dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04deb90fc45c132ac90d33b14885de58b835f1d9983ed5d26eee6b5a5f8bd964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "50a204dd740912a69a21a4f0074bcf86bf6a6d7c409b76ff7bfed6b7f0eb927e"
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
