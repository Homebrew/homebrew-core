class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.9.tgz"
  sha256 "383b47fd08735520aa938dcebefeb7775d986c02b73922f2f2241704d42c37e7"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "eb084c286d3a556eb98af23f07de340a9555173ed659e6d1481b9b3e9d543858"
    sha256               arm64_tahoe:       "eb084c286d3a556eb98af23f07de340a9555173ed659e6d1481b9b3e9d543858"
    sha256               arm64_sequoia:     "eb084c286d3a556eb98af23f07de340a9555173ed659e6d1481b9b3e9d543858"
    sha256 cellar: :any, arm64_linux:       "3d77755f4c98ea571ae1059fead8064fc2e36e4145f3738dea5c903311e68e2b"
    sha256 cellar: :any, x86_64_linux:      "9f0c84bc66ee4a0527d7221a95a3ac10feb1390e22d5c4bfaadf76c4dd168f81"
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
