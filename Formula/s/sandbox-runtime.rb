class SandboxRuntime < Formula
  desc "Lightweight sandboxing tool for filesystem and network restrictions"
  homepage "https://github.com/anthropic-experimental/sandbox-runtime"
  url "https://registry.npmjs.org/@anthropic-ai/sandbox-runtime/-/sandbox-runtime-0.0.1.tgz"
  sha256 "3b034b4afdb5d8fbb49d4bb9f7e3924bf8bb77612f9ed098800d157847904150"
  license "Apache-2.0"
  head "https://github.com/anthropic-experimental/sandbox-runtime.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@anthropic-ai/sandbox-runtime/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      Sandbox Runtime is a beta research preview. APIs and configuration formats may evolve.

      To use the CLI tool, run:
        srt --help

      For more information, visit:
        https://github.com/anthropic-experimental/sandbox-runtime
    EOS
  end

  test do
    output = shell_output("#{bin}/srt --version")
    assert_match version.to_s, output
  end
end
