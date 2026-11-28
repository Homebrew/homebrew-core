class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.28.7.tgz"
  sha256 "3bd80542c3660fcc07f9c987aad7dedc89b8564321583d17bf8d5438d536a6f6"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "d1a4f715ecfac91ec2b43b0bacb246bd98f9301203c6de6d51966108e3f14275"
    sha256               arm64_golden_gate: "4a7deff903a6ab0e7dbe4b65c40229725c1af5cc8ca839a62b5f0952a7ca51d5"
    sha256               arm64_tahoe:       "4a7deff903a6ab0e7dbe4b65c40229725c1af5cc8ca839a62b5f0952a7ca51d5"
    sha256               arm64_sequoia:     "4a7deff903a6ab0e7dbe4b65c40229725c1af5cc8ca839a62b5f0952a7ca51d5"
    sha256 cellar: :any, arm64_linux:       "2bacedf3c54ce46762ebc59dbf4ba307cbc0681ffdd1644278790a60ab5af606"
    sha256 cellar: :any, x86_64_linux:      "7fcd788bd5beed4d3f19f3161dd471c2429ef9b00d8cb8ff0b48a22d85c64534"
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
