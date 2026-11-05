class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.7.tgz"
  sha256 "4cb0587ce0eb368230b128ffd4ff999e7b517865145a26fdab14b7e744c307f0"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "5ac90d8eef8c6e9b5b9b4352dbd160085272163395ae5249cbd6a1adc16089e8"
    sha256               arm64_tahoe:       "5ac90d8eef8c6e9b5b9b4352dbd160085272163395ae5249cbd6a1adc16089e8"
    sha256               arm64_sequoia:     "5ac90d8eef8c6e9b5b9b4352dbd160085272163395ae5249cbd6a1adc16089e8"
    sha256 cellar: :any, arm64_linux:       "034221acdb98aa037e0509a0f29d7b2499aaf2ce2aa416e1d947c59e91b4aa20"
    sha256 cellar: :any, x86_64_linux:      "c99c3c8fa5868c84e5680f6743868c1cf34d4eafad1a2e6fd7135b5037a4a9c9"
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
