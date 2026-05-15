class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.11.tgz"
  sha256 "6692063c533cb119f4ef07b8deb2e53d8df48cadcc08e03a252bbb784d9cc075"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85584900b60f5089f32753b2ec4c195ed14860f38c2bd678a8e09e2bd12b8648"
    sha256 cellar: :any,                 arm64_sequoia: "063446616808acfdd0595d5a6a08914eb37fa031a37cde628edba23737900d87"
    sha256 cellar: :any,                 arm64_sonoma:  "063446616808acfdd0595d5a6a08914eb37fa031a37cde628edba23737900d87"
    sha256 cellar: :any,                 sonoma:        "eecd3a6f0433209528d27c5d905bccd95b65797039bea79251c1b0c2b47e695d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a1110513374cb87a0f643c68db790895ab2b5563000750e9676e285d78845a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c77fd393906791d2025ee5ec7fb2933157bead0903d572b1b79d1de23bdd02"
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
