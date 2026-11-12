class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.27.2.tgz"
  sha256 "3bdf4c84af2208ceaed5a6f8308504457fdb72d997eafba5b243061ad2d007bc"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "93a684c0514c844d7b297c86d4f4e8a2bd2e87483f7538ef217e49dd8219f67c"
    sha256               arm64_tahoe:       "93a684c0514c844d7b297c86d4f4e8a2bd2e87483f7538ef217e49dd8219f67c"
    sha256               arm64_sequoia:     "93a684c0514c844d7b297c86d4f4e8a2bd2e87483f7538ef217e49dd8219f67c"
    sha256 cellar: :any, arm64_linux:       "34a986088d489415503ec2ac45dd9a51896a293d4e63252c5b0a572a403970e2"
    sha256 cellar: :any, x86_64_linux:      "db371b69d6780d6ebd4c49202db7c35d36bffb8403ded7d0a4e76a6672446ad2"
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
