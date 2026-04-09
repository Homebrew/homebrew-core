class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.14.2.tgz"
  sha256 "9c30e7277f0e751b7b923a13f672b428e20d0923180231b399e0ffcd00a44407"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f06d3d97ae8c56d7a18bec53287f459ea34e04c57516a9e4fe1eaf0fa35b1f1"
    sha256 cellar: :any,                 arm64_sequoia: "3e6f25f115f3002a8d392aa31eb30aa143a3e8317768772ea0ca993cb1a16305"
    sha256 cellar: :any,                 arm64_sonoma:  "3e6f25f115f3002a8d392aa31eb30aa143a3e8317768772ea0ca993cb1a16305"
    sha256 cellar: :any,                 sonoma:        "578fb2c80c93db6775f010d179aaa5a0694300cdb3be1a54a822c0e6ebd43e01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2adc4d88a0494354a96b8e64ca04d27caf423316bf8c71fafab169252f83f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbc29830da34d83c7af4353f05a120ff1ad9af81783a9780573522e7bf774bc4"
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
