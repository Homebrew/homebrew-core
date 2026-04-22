class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.14.5.tgz"
  sha256 "201f91f46fe9c186c26c33ec45cab48ae14d891604c5ff580f877fc5b0fbb255"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3f9d07718bd765d5035ddd2c3b9226f3def2e539189e81251c539ef151727bb"
    sha256 cellar: :any,                 arm64_sequoia: "7ca3536a16512b3b374760722ed69f56acb69781ff6027627bc16c5aeb021440"
    sha256 cellar: :any,                 arm64_sonoma:  "7ca3536a16512b3b374760722ed69f56acb69781ff6027627bc16c5aeb021440"
    sha256 cellar: :any,                 sonoma:        "1a06be901031904933fa6cbb2f34a51a6f078b820e4a51d701fe54e0dc909c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb3f6dfc92747d6fed3c26ea544819f29bba7aa5788c24b5e33174ef0a5ade91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07297f7cc68bf830966a69fc2db1822ef463f5208df430740d42e6517deae8d5"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
