class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.28.6.tgz"
  sha256 "2b5890c758eb662f1f6e3ce84fd601d76dcf19c0ab37ab70325fe7fef83ef362"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "4575b2043b461d337801cf2a627737b9fd4a928d05d5143b97c387c63798ef68"
    sha256               arm64_golden_gate: "18784005e20d1220d91dd2af538ee8ba16d63b707bb2a5089364c6c1fd55e2b9"
    sha256               arm64_tahoe:       "18784005e20d1220d91dd2af538ee8ba16d63b707bb2a5089364c6c1fd55e2b9"
    sha256               arm64_sequoia:     "18784005e20d1220d91dd2af538ee8ba16d63b707bb2a5089364c6c1fd55e2b9"
    sha256 cellar: :any, arm64_linux:       "b5f84a98cba5c77b27d89efb22092674d71313c6592240415cbb48ffb139187d"
    sha256 cellar: :any, x86_64_linux:      "12f3a33b687af50706738972bc7c91fc819c2b675ef11669a40a34da8d0e9feb"
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
