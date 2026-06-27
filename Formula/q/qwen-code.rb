class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.2.tgz"
  sha256 "13e072d97332b21ed023cbe98c1f43805cc58dd636537e1bb30cc04c15df47bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f124d941273d425c98051175980f1b87cd5020263a1ef8399edbc2f7d5273f1"
    sha256 cellar: :any,                 arm64_sequoia: "99f99dd7107fc00a209b38b0ce4c18d64b961d7b645f5d93345383da6181fd3f"
    sha256 cellar: :any,                 arm64_sonoma:  "99f99dd7107fc00a209b38b0ce4c18d64b961d7b645f5d93345383da6181fd3f"
    sha256 cellar: :any,                 sonoma:        "5a3eec1fa6c8ade01f01dc89ba8a340d460fb9098d3a70df21ae2444a9300f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7c021dd033315f2076945a9455ceadac5944be7583552677cc0219c6f82de35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80928fdf9f22909b8fcf2749a378d1217d45a541e0a9bfa42d4781a1fb6caadd"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
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
