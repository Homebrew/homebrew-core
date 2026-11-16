class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.27.4.tgz"
  sha256 "fd6c4ed91379c7c8dd1fb168c5980984ef7e92019519296552afd5f6c08b8365"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "b37a5e6da39ff4c3a456a0f7ad07e82f9882963e66763dcbdfe40fe7e195a922"
    sha256               arm64_tahoe:       "b37a5e6da39ff4c3a456a0f7ad07e82f9882963e66763dcbdfe40fe7e195a922"
    sha256               arm64_sequoia:     "b37a5e6da39ff4c3a456a0f7ad07e82f9882963e66763dcbdfe40fe7e195a922"
    sha256 cellar: :any, arm64_linux:       "0050bdb4a7e3b920602d9b4cddfd89df8a1cac1228b85ba20d8aee3a45730170"
    sha256 cellar: :any, x86_64_linux:      "38d065f5c82c45cb174e3259ef4b340a45c3f7f62c65dcbe2f5aba7392dc3bcd"
  end

  depends_on "node"
  depends_on "ripgrep"

  # OpenTUI loads its native library by path, so keep its relocatable install name.
  preserve_rpath

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    qwen_code.glob("opentui-assets/@opentui/core-*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "core-#{os}-#{arch}"
    end

    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end

    qwen_code.glob("vendor/landlock-run/*-linux").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}"
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
