class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.17.1.tgz"
  sha256 "890d3d1971760226e7e9d3c22925a984e74d0edd319533bc6d3c8959ee50cf35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2585b533d8436a0e48ecbb0946452a64ba3475560ff1b2dec0e4bc2e07a1351f"
    sha256 cellar: :any,                 arm64_sequoia: "97038c73df12b701126f9eff873e56f5062e582e69d5ab83b76e892584c8ef3e"
    sha256 cellar: :any,                 arm64_sonoma:  "97038c73df12b701126f9eff873e56f5062e582e69d5ab83b76e892584c8ef3e"
    sha256 cellar: :any,                 sonoma:        "974b3f291305542c355030cf75fdb01ba9a2481f629f0e977082388b24dd608d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe700025443298bee86b52d1845929e616625f32a185d96285fdf97e27e1893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d8504b4ae3b3a390ff7682f5b6ec660601e0c74ef8bfea8e491578b19c8fa41"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
