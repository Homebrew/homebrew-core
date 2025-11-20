class RevealMd < Formula
  desc "Get beautiful reveal.js presentations from your Markdown files"
  homepage "https://github.com/webpro/reveal-md"
  url "https://registry.npmjs.org/reveal-md/-/reveal-md-6.1.4.tgz"
  sha256 "699d44c19f8437f294464ca457d35ad779e6f605299a38ea293b7aa75363d6f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc9effab791d9a047feab7dd5dbb0a788b4353f649863623e550f12778af400e"
    sha256 cellar: :any,                 arm64_sequoia: "e45cc89fa82e2c457d6882e2a8c960c23733207a6af5cf19cd5dd9adb22f3f70"
    sha256 cellar: :any,                 arm64_sonoma:  "e45cc89fa82e2c457d6882e2a8c960c23733207a6af5cf19cd5dd9adb22f3f70"
    sha256 cellar: :any,                 arm64_ventura: "e45cc89fa82e2c457d6882e2a8c960c23733207a6af5cf19cd5dd9adb22f3f70"
    sha256 cellar: :any,                 sonoma:        "f986662f9ae9064474e4725339175621ec6cee8b57a45d65e1c05c75cfdd1dae"
    sha256 cellar: :any,                 ventura:       "f986662f9ae9064474e4725339175621ec6cee8b57a45d65e1c05c75cfdd1dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd807b2193a54a49e0a09ef3dcb2edbe68734bd2aaa9f4e9bcbc22f7daded733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615e2c3e56083005d3c26f52b444f663a75e9222f92c59df41266506b0d65d2d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/reveal-md/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"test.md").write("# Hello, Reveal-md!")

    output_log = testpath/"output.log"
    pid = spawn bin/"reveal-md", testpath/"test.md", [:out, :err] => output_log.to_s
    sleep 8
    sleep 8 if OS.mac? && Hardware::CPU.intel?
    assert_match "Serving reveal.js", output_log.read

    assert_match version.to_s, shell_output("#{bin}/reveal-md --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
