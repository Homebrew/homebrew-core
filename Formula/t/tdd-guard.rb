class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.0.2.tgz"
  sha256 "48f51cd97aa68d55e8c7f63e6d1d9b039fab6053cc089977e4eaf3bdbaad0fcb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee8a64ddb4d76a23a6e662e0c466d0139d6396bb893d90a4397c23494c88b869"
    sha256 cellar: :any,                 arm64_sequoia: "ca1ab9cf72ab8b91045e9928532738bc6c32c0c3516c824c679f1a31dfcc6f17"
    sha256 cellar: :any,                 arm64_sonoma:  "ca1ab9cf72ab8b91045e9928532738bc6c32c0c3516c824c679f1a31dfcc6f17"
    sha256 cellar: :any,                 sonoma:        "f6261eae2320db8312e88ec28980d2a8e58db997b2f67b217738b48b75812ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6d18c0123e80b6aa5c944d6e90959551b096e97b473159f22f5874bd8ab1ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-code/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    (testpath/".env").write <<~EOS
      MODEL_TYPE=claude_cli
      USE_SYSTEM_CLAUDE=true
      LINTER_TYPE=eslint
    EOS

    input = <<~JSON
      {
        "event": "PreToolUse",
        "tool_use": {
          "name": "Write",
          "input": {
            "path": "example.py",
            "contents": "print('hello')"
          }
        }
      }
    JSON

    assert_match "reason", pipe_output(bin/"tdd-guard", input, 0)
  end
end
