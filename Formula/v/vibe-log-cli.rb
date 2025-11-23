class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.5.tgz"
  sha256 "d3febe4a8a999a02345c281f85a687445039dd0d22d4b1fe305785d5948e594e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5154ebb5ed4e50fdbd1c11cae0d5f2e77ee18c814536529486dde708cc2144bc"
    sha256 cellar: :any,                 arm64_sequoia: "496b5ce470ae6310729881627cdcdfe9df9a38a97c0bf1a109a8ef917842fcb1"
    sha256 cellar: :any,                 arm64_sonoma:  "15d10514f6c11baa2e0f95cf5f2946053f8f477db484764a2b3f5385be0c70b8"
    sha256 cellar: :any,                 sonoma:        "ab8c062c88611da55fd4ffb52a9931d60469e51039699287c83a73dd4a59b01b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c15044cfffd1c59232ac4749ec573aa91775b6a7aede066e52f627195a3c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a11a6e86878083cde7d658eb4672eb5c803bca5612d2b2ff9a144efe6b36a9b0"
  end

  # `better-sqlite3` needs to be built with `c++17`, but `node` v25  compile with `c++20` by default
  # Issue ref: https://github.com/WiseLibs/better-sqlite3/issues/1411
  depends_on "node@24"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    vendor_dir = libexec/"lib/node_modules/vibe-log-cli/node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end
