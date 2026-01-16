class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.7.1.tgz"
  sha256 "71155f6e9fbe9285ace10639d22bb60d8bad4cfa4f40c1530145522dea0225a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff7bc2a69346eb12739ed21f4eeeb356e922dff5e42780adc363f26d89d23f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7bc2a69346eb12739ed21f4eeeb356e922dff5e42780adc363f26d89d23f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff7bc2a69346eb12739ed21f4eeeb356e922dff5e42780adc363f26d89d23f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5eb5398ae39203a07d67bbbbaf48454306176cb40d3509e045a811166c4a508"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30b95250d2cb8e08db4a9da99f2afb1fa9fda4aa4b5e98880c2901a6d4c3f714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b13eb2a826aa72f215857c26fac1681bb0855e1ea48fa442395d170bbbcbe2c"
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
