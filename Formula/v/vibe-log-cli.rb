class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.4.tgz"
  sha256 "5c95548bb8354c827b45e7cf51b6be33e96c4f9cea867bd71ccbc2d9cf9f9a5f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f4de55a60c416745e6c08677f49e3b32cf20c17ccc5735e43de59eca260b623"
    sha256 cellar: :any,                 arm64_sequoia: "4fe730cfb74fac598c42f1f9372dafce1a479b0690d69095ee9ab02a340fb34a"
    sha256 cellar: :any,                 arm64_sonoma:  "530066958227ad80eb40c93751e7726ce5edf3e1279ee140c1d0e21690271dc7"
    sha256 cellar: :any,                 sonoma:        "85646ff1cc03ba7122116fabe2747df4dad4f533b63d10277228c5c0adcb9da2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9682b866ed6b028a1eb3adebee6d7588961eb883e89071191e385cfd77de29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3edce9ce8d799ff44bc06819739fc6f37facf61e318f990d5a70f3fa355314ae"
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
