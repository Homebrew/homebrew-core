class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.28.0.tgz"
  sha256 "32ca2695069210bae82410a8712d8658a7da5779ecbfcd67160adce415a4e1d9"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "9285c0db1029ffb52b70170a47587c668d6c471a7d45fedc1f57a1f9ea23392f"
    sha256               arm64_tahoe:       "9285c0db1029ffb52b70170a47587c668d6c471a7d45fedc1f57a1f9ea23392f"
    sha256               arm64_sequoia:     "9285c0db1029ffb52b70170a47587c668d6c471a7d45fedc1f57a1f9ea23392f"
    sha256 cellar: :any, arm64_linux:       "7509a306ebf679a430e34ef5305c6f267e127683de2548468f38568ee0235fdb"
    sha256 cellar: :any, x86_64_linux:      "c1dfaec417d3b857671327e0a99fd23dbcd698596c906dbe7ca24b8fbb4ca358"
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
