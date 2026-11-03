class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.6.tgz"
  sha256 "6d6889ae71ce6f3a892d597ba731edf1a45f34f3443ba1e55080511d1794b9cb"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "d02c79e15e2a3990985b79074811c7e831a87eb75e12cfe1ab06355490958790"
    sha256               arm64_tahoe:       "d02c79e15e2a3990985b79074811c7e831a87eb75e12cfe1ab06355490958790"
    sha256               arm64_sequoia:     "d02c79e15e2a3990985b79074811c7e831a87eb75e12cfe1ab06355490958790"
    sha256 cellar: :any, arm64_linux:       "ddb4f3251ad2d1db8a828a174aa77801029ea6eba5f0825c57c3558b1b72da12"
    sha256 cellar: :any, x86_64_linux:      "d4c543f757f4b4f4630de19b63de69b262a5292b15f545b84770a124d0174a04"
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
