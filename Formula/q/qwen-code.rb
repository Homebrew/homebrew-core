class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.12.6.tgz"
  sha256 "a5646fadf0a123fe67c9e7a22b9070f12bf37c74be574da7da25f1d97729fba1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cdcf2392f61736785cce39f6659cd83443c249b89be3ba0d7a791b333b762df"
    sha256 cellar: :any,                 arm64_sequoia: "b077bbe7b3e7cf3120a359e9164bc2acad183fe32ca2949628944f58a805f06a"
    sha256 cellar: :any,                 arm64_sonoma:  "b077bbe7b3e7cf3120a359e9164bc2acad183fe32ca2949628944f58a805f06a"
    sha256 cellar: :any,                 sonoma:        "41fffc0fcbb149ff3603243d0f28453e2eeaa7cfaeabf27dbda0ba14c1d301cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c3b7489ad240942d04a29aac2dacd2fec38fcef30fbbfd00d14cd7accce3c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b34893e9979b12759a98536fd7b0e960e588b9f40532c4d45e9eab3205f89c9"
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
