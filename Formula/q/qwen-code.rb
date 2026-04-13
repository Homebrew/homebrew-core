class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.14.3.tgz"
  sha256 "cb5968d5e128a8840a81ea9072150eb39c852b1cd92ba386dd4635ccd2e64b73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "779e7a7e646bf91cb131d286de1c0804ae87875ac0ce72ebc4c9b9e4f1bb3b8c"
    sha256 cellar: :any,                 arm64_sequoia: "034983b7216c30951adace8a696a50fcbca7f66de584d00e7ee9cb8ef4cfafff"
    sha256 cellar: :any,                 arm64_sonoma:  "034983b7216c30951adace8a696a50fcbca7f66de584d00e7ee9cb8ef4cfafff"
    sha256 cellar: :any,                 sonoma:        "e1d0ad1d14ab181225e1c1bea7a05952066e6b114bdc22fe372bbf73218dd7f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b95cd3a6120aeea610f6d5b72e60e00d403f9bb6c6ea7be01e7eec327ddb6b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7adbd6c34bebd04f8c4315103f67c3cc416a053a7a88930dfbedecb042cc2ad8"
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
