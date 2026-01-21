class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.7.2.tgz"
  sha256 "eff2138dbea2215db872e3c50db3321e056c7f0e5abf5b94224aec9e88967594"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15cd83b3f8be11ac7faae710529d65b8c42dd233e8a6d50ed2fc7aca2cbe5f40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15cd83b3f8be11ac7faae710529d65b8c42dd233e8a6d50ed2fc7aca2cbe5f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15cd83b3f8be11ac7faae710529d65b8c42dd233e8a6d50ed2fc7aca2cbe5f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "77d3b67ce9e650aad1b47f1f54d92c19d7225be58becd9e3dbac4291db9a6a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62a7bf1fd6f1e10d0b77f7c99d0cdbf1932140a51280ee78c0eaa52d84dd7546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ae9caa02f696cd5fb338284a953bed7e10e25ae6074b3438bfa408717b2b32"
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
