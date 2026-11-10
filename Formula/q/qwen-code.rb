class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.27.1.tgz"
  sha256 "c4b2f0f92f7076456c45bc22d714000c6f240a85a2ab6e55ded806696f05581a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "a4a6ff8d441ae9e7d3e3bbb6f8ff7feb085f4b6b48a38ee2082b43c45dace478"
    sha256               arm64_tahoe:       "a4a6ff8d441ae9e7d3e3bbb6f8ff7feb085f4b6b48a38ee2082b43c45dace478"
    sha256               arm64_sequoia:     "a4a6ff8d441ae9e7d3e3bbb6f8ff7feb085f4b6b48a38ee2082b43c45dace478"
    sha256 cellar: :any, arm64_linux:       "25ec3d10224b5cae79d1a6a0f101f4af94b705e158f53dc9c7929d14ab210cc3"
    sha256 cellar: :any, x86_64_linux:      "4c8aa74eac6790221d40dc343bcef58a9abdc0b4a43bc7b6a186301076ec2abb"
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
