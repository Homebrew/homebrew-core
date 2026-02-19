class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.10.5.tgz"
  sha256 "e3c5e7a93472e797c625a5f7c95e99d77b7f700e32c543d68edd2ff10a46b95b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71912f7983e1cbf483c2877b39b90555e82ead8b01026742463e9bf22aec3e49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71912f7983e1cbf483c2877b39b90555e82ead8b01026742463e9bf22aec3e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71912f7983e1cbf483c2877b39b90555e82ead8b01026742463e9bf22aec3e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "4caa4c8067b3c56930b183fe7ac902cc0e0bc26a59d686ef5ac04008e774fa5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec22023ba9b51ae0077f1eddd596b2a32e67eb37c8cd9919b041dcbca477de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a38afc44c3cd0a1695845005bfe65ee0aa05df9e56d483a9b7b76961f0e5a2a"
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
