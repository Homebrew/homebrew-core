class TddGuard < Formula
  desc "Automated TDD enforcement for Claude Code"
  homepage "https://github.com/nizos/tdd-guard"
  url "https://registry.npmjs.org/tdd-guard/-/tdd-guard-1.1.0.tgz"
  sha256 "f9da65d258979704097f6646190473a31080e05909ab54c814b8d902a8938087"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fb3feb1c6e6a4b7f4b36982a45445b69e2845212e85c4318c49e1b53ceaebb7"
    sha256 cellar: :any,                 arm64_sequoia: "9fb17dde7acb7f69dcdb60339c839e9eaf83935be59b6728c42f286ce26678ae"
    sha256 cellar: :any,                 arm64_sonoma:  "9fb17dde7acb7f69dcdb60339c839e9eaf83935be59b6728c42f286ce26678ae"
    sha256 cellar: :any,                 sonoma:        "ea1930bf4be0a3f3d86f01f8be7ad0c5b231d510c30220c50f25d174cb21fdaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db9e7258bed48c9637a0eef9fdc5e08924d0cf30acca05fada8a46fffdfa690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca2b4d222c93da8b4a5dddc4e7218e51b39e9b420fcec6be899cd157d63d9e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/tdd-guard/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
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
