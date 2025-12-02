class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.5.tgz"
  sha256 "d3febe4a8a999a02345c281f85a687445039dd0d22d4b1fe305785d5948e594e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a407c8fd32af2faa009f1186e76ad9ee6172385ed63a692b2a5abd133a45b027"
    sha256 cellar: :any,                 arm64_sequoia: "a4f88cc5b528a0d661d4b2e20efe8782c6710b26a396c0ab0ac5ed790a2697c7"
    sha256 cellar: :any,                 arm64_sonoma:  "3239e1998b5c0c008d2ffca43553ea4176cb7a42099214a8d7ee381830e66925"
    sha256 cellar: :any,                 sonoma:        "54d3b4cd39e6a2e373ee018c90e7ffb94efba235425052414061962f778da644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23043125891fed986515d2511a5c83e0702ab46c56b572792b151d4b0d94f5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d9087b46b4eb82268dd2faf671ecd80a460a38a1a0396edef33ee57d35f2617"
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
