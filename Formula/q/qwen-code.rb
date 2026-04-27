class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.2.tgz"
  sha256 "b4bc913e79d546a974cdc673aeb49852f41c3543cb129d2629272b3d3757b1a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ceb5c2f29bee5397746c6157822976a54f2a8a12f218c97f387f71982f38eca9"
    sha256 cellar: :any,                 arm64_sequoia: "a6268b267768f0940284219807a17099275faf17590eca02b738e988d8f597b8"
    sha256 cellar: :any,                 arm64_sonoma:  "a6268b267768f0940284219807a17099275faf17590eca02b738e988d8f597b8"
    sha256 cellar: :any,                 sonoma:        "e950817fdffae5ef45c7e3e1220d11a2d8c56e4926e74e2adf625713ffd625bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47600f57f9964f1ba487b2d380c8fb3b9498ba2792a7ab1c4323c2ff3827c983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19fdc2db289cf39a8f579e66aaaaccdde851106ecf43898a537cbf613ea52f2e"
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
