class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.27.0.tgz"
  sha256 "dd1c502c7c545537d93b240a940c4678f5b268a3cf96ab617daa34d6bc4ba8d7"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "380413da8c5ed3025b43cda2bb01b0979f7723acbfeb76a7e51907b98ad0d2ed"
    sha256               arm64_tahoe:       "380413da8c5ed3025b43cda2bb01b0979f7723acbfeb76a7e51907b98ad0d2ed"
    sha256               arm64_sequoia:     "380413da8c5ed3025b43cda2bb01b0979f7723acbfeb76a7e51907b98ad0d2ed"
    sha256 cellar: :any, arm64_linux:       "b7d6f96b9801e8149b6a2b0a862aedde93aa679e45673354344cc80086559b97"
    sha256 cellar: :any, x86_64_linux:      "683049412249f6024bb6b3f6f011fb785fcb3be223a4e92c044ec1d71f76f0b3"
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
