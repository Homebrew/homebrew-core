class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.7.tgz"
  sha256 "88b64cac32e8c273103fd603ac0c1a995e871145f0fad183ad68a3f515669c7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "052abb30fcf1be6599097ecc586d50cfac01b51c54995677e534441c122e0987"
    sha256 cellar: :any,                 arm64_sequoia: "31bdb416ec789d8925c97fe374c4cda024862375bfea98e85ad4c5d4d8506d98"
    sha256 cellar: :any,                 arm64_sonoma:  "31bdb416ec789d8925c97fe374c4cda024862375bfea98e85ad4c5d4d8506d98"
    sha256 cellar: :any,                 sonoma:        "a9250205bb57488a9d901bb75721a664b62a2c8f92105a538007ad12510d1ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d2efe411ceb5da12c5bf3ff3435027a44390f53fc1db7c067e2a6aa71845d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0befee177072b176cec0a08f4af79d3844dd5ac28cbf0aa9dadc860ed33687ff"
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
