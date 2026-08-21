class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.15.tgz"
  sha256 "8d405b065888b7000a6989d99c2d79257cd8f9f5b68e9078fb76484527351b9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "618beefe3f5f5333a940722190019dad6996ad9168e998cd0e54d1100c808d02"
    sha256 cellar: :any, arm64_sequoia: "618beefe3f5f5333a940722190019dad6996ad9168e998cd0e54d1100c808d02"
    sha256 cellar: :any, arm64_sonoma:  "618beefe3f5f5333a940722190019dad6996ad9168e998cd0e54d1100c808d02"
    sha256 cellar: :any, sonoma:        "b0c475385afd4d8c86cbde96a398e1e2074c100fab47620c055d5aa59d61cae2"
    sha256 cellar: :any, arm64_linux:   "2eca09d19b6d635f466ea8d7869beb9e1831a9a691ad60c6e0f26090c8bd286e"
    sha256 cellar: :any, x86_64_linux:  "ae7ab977f4f0593c68af45265a0615cee94251f719d53006f4c0eb28ffe5c9e2"
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
