class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.23.0.tgz"
  sha256 "1ca5d9816557f2fea58570aab5c9638fb6252b77abad6a36245dd7eced413e27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eace2019969f58deda33f86ed9cd30b47cd6d46eb5d3d8ad941c5fde1ad1caaa"
    sha256 cellar: :any, arm64_sequoia: "eace2019969f58deda33f86ed9cd30b47cd6d46eb5d3d8ad941c5fde1ad1caaa"
    sha256 cellar: :any, arm64_sonoma:  "eace2019969f58deda33f86ed9cd30b47cd6d46eb5d3d8ad941c5fde1ad1caaa"
    sha256 cellar: :any, arm64_linux:   "5730d57dc7ccd1aa0015d2321c9091991eaffe2b151e1af3d571cacd0f505d1b"
    sha256 cellar: :any, x86_64_linux:  "ef3cdef5005ddd8e6a2844c3d725e441cc39be973a353f1629d0add64df0edba"
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
