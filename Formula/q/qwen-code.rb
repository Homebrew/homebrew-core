class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.28.4.tgz"
  sha256 "bd9daa7bef7ab4cccea8f74372d1924f54637412f73bd21242e6740c145fdfc5"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "3434968c6fda8bacb482fabb4b07c396be30f83967db41c02422bc636368155a"
    sha256               arm64_golden_gate: "7e85459b486a28493562ef99dc51959d3e67c191a4d808c44527fbd91d195abc"
    sha256               arm64_tahoe:       "7e85459b486a28493562ef99dc51959d3e67c191a4d808c44527fbd91d195abc"
    sha256               arm64_sequoia:     "7e85459b486a28493562ef99dc51959d3e67c191a4d808c44527fbd91d195abc"
    sha256 cellar: :any, arm64_linux:       "d573390989979f1e81bdee2aa06d4045b5b998843aed89ae07ae347e03ec27bc"
    sha256 cellar: :any, x86_64_linux:      "c63b6714e19e9ec6adc568662ef84907b79554e8eb84afed85749ee15527cf36"
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
