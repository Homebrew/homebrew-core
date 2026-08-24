class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.22.0.tgz"
  sha256 "c0ae0ad006c4dd8b69ebe1705d13bb57d37d1c808dcb891c5bfcde91e66670c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fbab4bb1d15842704f7aced7c27f6d6b51fffe3f9f02d7347bcb6e69c5dbec5b"
    sha256 cellar: :any, arm64_sequoia: "fbab4bb1d15842704f7aced7c27f6d6b51fffe3f9f02d7347bcb6e69c5dbec5b"
    sha256 cellar: :any, arm64_sonoma:  "fbab4bb1d15842704f7aced7c27f6d6b51fffe3f9f02d7347bcb6e69c5dbec5b"
    sha256 cellar: :any, sonoma:        "041f709ab2408e6c27996b3a094f33b582c4ff4c0bc903f8f1b72f8cf7b14c6e"
    sha256 cellar: :any, arm64_linux:   "dea2356339b5a16dd592857bbe456a70d0dc9b227bb27824040ce37666851c9d"
    sha256 cellar: :any, x86_64_linux:  "3ec373f15cc68953d26fd679946d7573815de85339a73162f32e5516c3d76eca"
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

    qwen_code.glob("node_modules/@qwen-code/audio-capture/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
