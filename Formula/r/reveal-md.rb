class RevealMd < Formula
  desc "Get beautiful reveal.js presentations from your Markdown files"
  homepage "https://github.com/webpro/reveal-md"
  url "https://registry.npmjs.org/reveal-md/-/reveal-md-6.1.4.tgz"
  sha256 "699d44c19f8437f294464ca457d35ad779e6f605299a38ea293b7aa75363d6f9"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/reveal-md/node_modules"
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"test.md").write("# Hello, Reveal-md!")

    output_log = testpath/"output.log"
    pid = spawn(bin/"reveal-md", testpath/"test.md", [:out, :err] => output_log.to_s)
    sleep 1
    assert_match "Serving reveal.js", output_log.read

    assert_match version.to_s, shell_output("#{bin}/reveal-md --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
