class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.26.5.tgz"
  sha256 "fb8dd2b327beedbe639966fca24d27b1b2860b148b78628812178262af871d1a"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "29db771a609786a76cb9bc234e9e5841ad6f0ecaeac6940790f417008c682c9b"
    sha256               arm64_tahoe:       "29db771a609786a76cb9bc234e9e5841ad6f0ecaeac6940790f417008c682c9b"
    sha256               arm64_sequoia:     "29db771a609786a76cb9bc234e9e5841ad6f0ecaeac6940790f417008c682c9b"
    sha256 cellar: :any, arm64_linux:       "97e4a371555fe28329f696b9ccd8df61b13b1515e558fbcb7c3a4a46f77e6009"
    sha256 cellar: :any, x86_64_linux:      "01ae793865524b7bc8f8abc7d02f8745c5b0a7aa729651377b20e2ed81b16b15"
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
