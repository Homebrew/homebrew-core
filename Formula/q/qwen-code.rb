class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.0.tgz"
  sha256 "f98be440edef481c0d2e13b959091eb60377d334469a6f1601a30b0f10258ef5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d282e7c514c47a1b516e6f3d652cb7f9cdd137ca22f6b32ca004fba910deefa7"
    sha256 cellar: :any,                 arm64_sequoia: "e7dd54c6e75297e736ef5ff6bb9694a403d176227bbb81436ae7849fa473bc43"
    sha256 cellar: :any,                 arm64_sonoma:  "e7dd54c6e75297e736ef5ff6bb9694a403d176227bbb81436ae7849fa473bc43"
    sha256 cellar: :any,                 sonoma:        "0376973b99b437e44e9d7d56909964ecde69dff787263b635e0af41b4b3370d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ff8f5706bd98051d51654c451bc080febcb8560a4c14f730079876930616bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c277bead40a1a3e1618dc69263f8aa46367d88e819492410306feeda9020a6"
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
