class Rea < Formula
  desc "Reverse engineering CLI and MCP server for agents"
  homepage "https://github.com/morluto/rea"
  url "https://registry.npmjs.org/rea-agents/-/rea-agents-6.10.1.tgz"
  sha256 "e8cf08c9fa954e998fc8868c23fa8e5f518cdb9553488ec227b31a3bb6903150"
  license "MIT"

  bottle do
    manifest_sha256 "cfdd19d978c7dfccdea0ca3dbc84629d87782e4976c16e85a0470d8d2e0cdded"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a4cde9b4b019f427c465318bcc9367aa7da45bb528ebe4498af076dd6ead5a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a4cde9b4b019f427c465318bcc9367aa7da45bb528ebe4498af076dd6ead5a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a4cde9b4b019f427c465318bcc9367aa7da45bb528ebe4498af076dd6ead5a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c7a6cfa4ee1945f0bcc40942e64882787cc127edcd45928c283e0fd2302ac1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6c7a6cfa4ee1945f0bcc40942e64882787cc127edcd45928c283e0fd2302ac1a"
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
