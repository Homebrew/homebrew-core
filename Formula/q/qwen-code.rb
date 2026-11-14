class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.27.3.tgz"
  sha256 "313a567f05dd036b489b9142b0f20f21dfe348532e5d07b6f0818a47c5ac5333"
  license "Apache-2.0"

  bottle do
    sha256               arm64_golden_gate: "23900942752504ae52da50774bb02e01a7de8e35d9affd60eb0c8db52d047fd2"
    sha256               arm64_tahoe:       "23900942752504ae52da50774bb02e01a7de8e35d9affd60eb0c8db52d047fd2"
    sha256               arm64_sequoia:     "23900942752504ae52da50774bb02e01a7de8e35d9affd60eb0c8db52d047fd2"
    sha256 cellar: :any, arm64_linux:       "5be22d8dbff483378ffa8b1e20d58687514286e222d388b420ff968a3f59d972"
    sha256 cellar: :any, x86_64_linux:      "a81e27482b843e9c6eaaa5d01e4901dcb8f25a29cff4a951149ac67b50405398"
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
