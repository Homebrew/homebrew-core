class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.2.tgz"
  sha256 "94ccc5d0bb34476f3dcf7729970c7697a8921b28e0784617e6a2b15370d5f2de"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63cac5c2d7a97bb19d6d0c7217a2e78a21fdbfc24cf4b20ec5b94ded53c798ce"
    sha256 cellar: :any,                 arm64_sequoia: "73f71c883537760d0e82ebe5d587c9dba4c96e02dd5db474f4982db32b7c9a26"
    sha256 cellar: :any,                 arm64_sonoma:  "ec6a7d26abfb6c233998c0b5551cde417f9842a0275ca84395a65a1d6b6daf0c"
    sha256 cellar: :any,                 sonoma:        "68a108b2e5cfbabfab0e01c83b8cdb6955ac0a41f03352f3f932899c2297cd53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b58a1c6109a51d984747765208431296c1ecaf8e8cc80a66862bf32acd493d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7ec478942dda6072c74a95e785b60854ccd5d97649649bb206e5805c5f1f4b"
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
