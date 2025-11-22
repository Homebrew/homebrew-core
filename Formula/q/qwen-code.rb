class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.2.3.tgz"
  sha256 "9c6d1d3771043d6e1df7f2b072d629066f07021db18113cafa455e438723e032"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "d31aa62fa340452bf765eb9161ec4d7ea46d4c67fa9d76b2743a058e8a1e02e1"
    sha256                               arm64_sequoia: "bb6412c9bfd031b5ace26b7fd241dbe0204f88d900812c5df71cec1a66363164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47850182be429edb0e29e74843589e0afb65d44a63b32ad411516a443e35889"
    sha256 cellar: :any_skip_relocation, sonoma:        "d584378ffbd9e9eb3c145622056565866e91d22a6fa1d1daf7dd46ea941355ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5fd0d1985b9c4945114be4105ab3b0c517af98660920477b8c6999d054e00d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "419ac051fd86465709ec1b81570c0f1722e9f7f1bb71aecb588ca81b4b83beb7"
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
