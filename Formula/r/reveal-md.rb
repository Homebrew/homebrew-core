class RevealMd < Formula
  desc "Get beautiful reveal.js presentations from your Markdown files"
  homepage "https://github.com/webpro/reveal-md"
  url "https://registry.npmjs.org/reveal-md/-/reveal-md-6.1.4.tgz"
  sha256 "699d44c19f8437f294464ca457d35ad779e6f605299a38ea293b7aa75363d6f9"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "9894ad668b98aac5215a89bdd31e39be7d73962f1d8101690c6022154e9c6f1a"
    sha256 cellar: :any, arm64_tahoe:       "9894ad668b98aac5215a89bdd31e39be7d73962f1d8101690c6022154e9c6f1a"
    sha256 cellar: :any, arm64_sequoia:     "9894ad668b98aac5215a89bdd31e39be7d73962f1d8101690c6022154e9c6f1a"
    sha256 cellar: :any, arm64_linux:       "dbde45bb72ba1e3d9fb548473ff026e1d4379abac971885236b1c365252c499c"
    sha256 cellar: :any, x86_64_linux:      "45100cb1686b30fdddbfc5cc0b516346dcf8c6170eac86edfbbcb52cbad2da4d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/reveal-md/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"test.md").write("# Hello, Reveal-md!")

    output_log = testpath/"output.log"
    pid = spawn bin/"reveal-md", testpath/"test.md", [:out, :err] => output_log.to_s
    sleep 8
    assert_match "Serving reveal.js", output_log.read

    assert_match version.to_s, shell_output("#{bin}/reveal-md --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
