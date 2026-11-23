class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.28.4.tgz"
  sha256 "bd9daa7bef7ab4cccea8f74372d1924f54637412f73bd21242e6740c145fdfc5"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "bb5a66700504fcf7d7f7058e183d309f66ece781f6ac7bc8845960ee4ba5b8c7"
    sha256               arm64_golden_gate: "3374c5c25d249d57eee5305238913f1641f4a148e2ba4f4fd14203ea833650c1"
    sha256               arm64_tahoe:       "3374c5c25d249d57eee5305238913f1641f4a148e2ba4f4fd14203ea833650c1"
    sha256               arm64_sequoia:     "3374c5c25d249d57eee5305238913f1641f4a148e2ba4f4fd14203ea833650c1"
    sha256 cellar: :any, arm64_linux:       "80cfb23517f38e58692b57d87d1fed74de23e8d796c42281bd840fa892ba2b88"
    sha256 cellar: :any, x86_64_linux:      "deba77164adf09fe0bf14455dd9ea6db464760a262e38a010726db5bfb4c47e5"
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
