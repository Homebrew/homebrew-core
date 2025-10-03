class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.14.tgz"
  sha256 "aecde8ce4154ff9d55f459e94e04029ecbf09426dfada0cbe97da71964f12352"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "a9f29cc07fbcfb267e802df01fd0a0b28f55c13df53ebc54eacda04665ddfd70"
    sha256                               arm64_sequoia: "2b865bff0f651169e7f4b765bd082303b50e6fea05158d396b55886cbda47f9f"
    sha256                               arm64_sonoma:  "ee6c61b92c8c10455445b4717ed3a5eff477cbd43325fb2436eb234cb3b2aba1"
    sha256                               sonoma:        "3341ada0c797840b802bcf60ecffba0def9956d546005de261ebf38ed3ee4ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4b1c9bce93a5d8d0c78f355cee0aa0b5c0b62d212d8278db86efd35597a67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550f7984b2a6549ca22cbc5c03ad42a9c68d05f753bdb21e221933f4ebffb801"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
