class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.8.tgz"
  sha256 "9233a8f8e88404a3a5ee4f23c99bf7145edc8deb97635c71b8e73b24b2d899d3"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "e6669410be4f523cc38eda95e62aa9c12a7303b98c69628ca903f8b784f6ed4e"
    sha256               arm64_tahoe:       "e6669410be4f523cc38eda95e62aa9c12a7303b98c69628ca903f8b784f6ed4e"
    sha256               arm64_sequoia:     "e6669410be4f523cc38eda95e62aa9c12a7303b98c69628ca903f8b784f6ed4e"
    sha256 cellar: :any, arm64_linux:       "b011ad3c499f8aa65dd8682f0760253deabd4e68555e4840cca70f2052814e63"
    sha256 cellar: :any, x86_64_linux:      "416568b3a3cb5ffcadc81944c77037b9d6c588ab9e23d1e02be7734360cedccb"
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
