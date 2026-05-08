class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.7.tgz"
  sha256 "9a9501ea6efe3f59476caa9a2cd33c34a97717093d20819cea2b33b77e2a6b6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ef964d072c19ab283dfa3d0b6d3c037cb1ce48772ff991115295876b816d070"
    sha256 cellar: :any,                 arm64_sequoia: "e5e38519734bee59ebab6574314845c0ad8d16631e8fc4295b24e85c6bfa50ca"
    sha256 cellar: :any,                 arm64_sonoma:  "e5e38519734bee59ebab6574314845c0ad8d16631e8fc4295b24e85c6bfa50ca"
    sha256 cellar: :any,                 sonoma:        "1db091fadefc649ede150bf3b32025515ba0714bc1812c4ff4dbfb10dae4d207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b224012931d8e06f417f86a523b08fdd6d34a41018939ae60772a2e7a653492d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22304a74e04c1410e36c374068579cd175b30f329efd6ad6f8ef38d4f953234e"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
