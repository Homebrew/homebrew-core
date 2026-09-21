class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.2.tgz"
  sha256 "ea8b977eac79977603f52c9a3f4d279f3f70e230910a087372a51d70cd2759fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b5fe944e19395a408c5fcd0351a189bf2bb84b14e077f52111a71c787b46d4a1"
    sha256 cellar: :any, arm64_tahoe:       "b5fe944e19395a408c5fcd0351a189bf2bb84b14e077f52111a71c787b46d4a1"
    sha256 cellar: :any, arm64_sequoia:     "b5fe944e19395a408c5fcd0351a189bf2bb84b14e077f52111a71c787b46d4a1"
    sha256 cellar: :any, arm64_linux:       "5e818de449ae4fae7b764cdc1e688781c8c63360f9868d5cccf135f62b86866c"
    sha256 cellar: :any, x86_64_linux:      "bfd1f0c55aac04c24c9041c7cc0419f5edf2ee1009b8fed93de31462fd1e068f"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    qwen_code.glob("node_modules/@qwen-code/audio-capture/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
