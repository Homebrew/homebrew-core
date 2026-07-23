class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.20.1.tgz"
  sha256 "eb351ff7bcd0c583df252e125325634362ea754d1f9cc4cd69b9797ce89bf0de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e783e45858125442320b1d21ac0ff6aa4a05a7e3fc9b800575d843d519e7070"
    sha256 cellar: :any,                 arm64_sequoia: "5e783e45858125442320b1d21ac0ff6aa4a05a7e3fc9b800575d843d519e7070"
    sha256 cellar: :any,                 arm64_sonoma:  "5e783e45858125442320b1d21ac0ff6aa4a05a7e3fc9b800575d843d519e7070"
    sha256 cellar: :any,                 sonoma:        "064d631874f2ccbd00ccb604255b590ccf1ae645ca2486c5d8acf21c47da8a12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12ed146507f48fbd7eca97c3834569c69aa7d0abf2c5bc3128c5c2f2961710ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8620c682542c915fe1fa9a433f50d04eb48ab3f3fe43b96cea858f6b9a0a45a5"
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
