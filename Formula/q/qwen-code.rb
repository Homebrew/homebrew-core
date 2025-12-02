class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.3.0.tgz"
  sha256 "ac476fee5b14877848767c19077f986d07e08075ca92b22e77f102bd43978157"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30dd157b3f8446c44a7703426d59ecd0c0ee885932c19a57ba18e5650ef42097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30dd157b3f8446c44a7703426d59ecd0c0ee885932c19a57ba18e5650ef42097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30dd157b3f8446c44a7703426d59ecd0c0ee885932c19a57ba18e5650ef42097"
    sha256 cellar: :any_skip_relocation, sonoma:        "664ebd8cd163a2a381b056566b7b64be33fdb578d231fb34e1e7c3daf7543b65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb634b7017386669b7939209b4bcf6c48e5927c5cbd3405d1947efc4f521d79b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "506fb08a37a4f5dd2fe52f72c422d0f4395da81ddd1b7ff27a109ec0e79ddd24"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    rm_r(libexec/"lib/node_modules/@qwen-code/qwen-code/vendor/ripgrep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
