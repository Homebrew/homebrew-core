class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.6.tgz"
  sha256 "25c321dcf0ac2c53eec2cb4b0d8756d0b074e31948ed9dce85a690d7a38f65de"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d22f63eb82b6305b4d01783da6fa58576439543426959b744cf2077614932bfd"
    sha256 cellar: :any,                 arm64_sequoia: "ea482c418d6c6b3794b007dd92173450d7a3ad7f0a7568360edfcd64c065f51d"
    sha256 cellar: :any,                 arm64_sonoma:  "ea482c418d6c6b3794b007dd92173450d7a3ad7f0a7568360edfcd64c065f51d"
    sha256 cellar: :any,                 sonoma:        "b7db1b7538ada62ba0abfea8d470d8d47129932cbe4bc5032eeb6260f56dec31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceadc326f52c5c68e37836061530141d9a839909a263eb727b3d2ace3ab50727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e4ba2de3d30630e789250d8d5198ccf39169d31a0e1035ed43ff90968e1fb5"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    # Allow newer better-sqlite: https://github.com/vibe-log/vibe-log-cli/pull/11
    inreplace "package.json", '"better-sqlite3": "^11.0.0"', '"better-sqlite3": "^12.0.0"'
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/vibe-log-cli/node_modules"
    vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
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
