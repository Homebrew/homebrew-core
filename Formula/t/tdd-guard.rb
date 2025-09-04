class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-0.11.0.tgz"
  sha256 "4e1ecd682bb6756f8a076d00e47fc512300912f66092b31e92a333d3ec071f04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "382c7d21a2adbb8e4c6eb3e3f82d887215a3ac1cdb76b2e6810fffa03f2d136c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
