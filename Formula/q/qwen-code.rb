class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.5.tgz"
  sha256 "fb8dd2b327beedbe639966fca24d27b1b2860b148b78628812178262af871d1a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "26c6da442667a64e49c3576a449f0a1b099e2a35663b9e0a3b294f88a2196495"
    sha256               arm64_tahoe:       "26c6da442667a64e49c3576a449f0a1b099e2a35663b9e0a3b294f88a2196495"
    sha256               arm64_sequoia:     "26c6da442667a64e49c3576a449f0a1b099e2a35663b9e0a3b294f88a2196495"
    sha256 cellar: :any, arm64_linux:       "047011cf42192e2bdb16add6ab3dda76606f98d949a8b2aa8501ddb1f83f7392"
    sha256 cellar: :any, x86_64_linux:      "83ea06a7a298a338dc7845035a057a248e580272cedaef28104afe5f33a82ab5"
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
