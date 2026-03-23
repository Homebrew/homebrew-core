class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.13.0.tgz"
  sha256 "189b759aae1bfd77329cf67d9b457d760040d3f759dee4df2eaab2dfa7febf69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34c635a442b37bb37f1718904420281d5a7f2f0e5e7c82e869b470bcbdf3db54"
    sha256 cellar: :any,                 arm64_sequoia: "4335cbb4013a0abc3a63ab1d5ace7050ae716940a4e1a2f73521c83e903c1df0"
    sha256 cellar: :any,                 arm64_sonoma:  "4335cbb4013a0abc3a63ab1d5ace7050ae716940a4e1a2f73521c83e903c1df0"
    sha256 cellar: :any,                 sonoma:        "e02d66979749ac66c3b01a8dd76710f429de02b920c88450cf5282676d5646c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c8a9fac4216ddd64aecdd03621ba7ffdb9ab70a29a8600b0983323ef221754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bec8f26b6cd3dd8132d68b8c6b4f958b557269b7b1b0ced8cd6fef581a7afa"
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
