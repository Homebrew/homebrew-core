class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.25.3.tgz"
  sha256 "e6e5d1b7ffd7442d16f6c0e3954bd5a69dbf81b0ae224f7fb6f3558d93be2742"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "84d43b0f7a140a64332aabb958269a2bcff460416b5729ff48cae1f5beb2cfcc"
    sha256 cellar: :any, arm64_tahoe:       "84d43b0f7a140a64332aabb958269a2bcff460416b5729ff48cae1f5beb2cfcc"
    sha256 cellar: :any, arm64_sequoia:     "84d43b0f7a140a64332aabb958269a2bcff460416b5729ff48cae1f5beb2cfcc"
    sha256 cellar: :any, arm64_linux:       "116710c31d7db39ffb63df610d627bbc78b218ef1c82929fa4d4caf76f913689"
    sha256 cellar: :any, x86_64_linux:      "c262e6f08356cc9c682dc8ab3d2beaa92ea2ab934d8be4dbdc5e01f1cef48e4f"
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
